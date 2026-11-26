"""Pre-release fixtures for the manual Release 3 promotion interlocks."""
import hashlib
import json
import unittest

import check_release3_promotion as promotion


def encode(obj):
    return json.dumps(obj, sort_keys=True).encode()


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


class PromotionTests(unittest.TestCase):
    def setUp(self):
        self.source, self.tag, self.revision, self.tree = (n * 40 for n in "abcd")
        self.api = promotion.REPO_API
        self.base = (f"https://raw.githubusercontent.com/{promotion.release.API_REPOSITORY}"
                     f"/{self.revision}/packages/v0.3.0")
        self.marker_url = promotion.release.API_URL + promotion.MARKER
        self.receipt_url = self.base + "/receipt.json"
        self.published_url = self.api + "/releases/tags/v0.3.0"
        self.marker = {"schema": "lean-info-theory.versioned-api.v1", "version": "v0.3.0",
                       "purpose": "candidate", "source_mode": "github", "source_identity": self.source,
                       "source_tree": self.tree, "validated_passes": 2,
                       "raw_tree_sha256": "a" * 64, "api_attestation_sha256": "b" * 64}
        self.receipt = {"schema": "lean-info-theory.release3-pages.v1", "purpose": "candidate",
                        "source": self.source, "source_tree": self.tree,
                        "sites": {site: {"sha256": "c" * 64} for site in
                                  ("LeanInfoTheory", "LeanInfoTheory-API", "LeanInfoTheory-API-v0.3.0")},
                        "api_attestation_sha256": "b" * 64, "api_raw_sha256": "a" * 64,
                        "api_stage_sha256": sha(encode(self.marker))}
        self.pins = {"release_commit": self.source, "annotated_tag": self.tag,
                     "bundles_revision": self.revision, "receipt_sha256": sha(encode(self.receipt)),
                     "archives": {site: {"zip_sha256": "e" * 64, "tar_sha256": "f" * 64}
                                  for site in ("main", "api")}}
        self.public = {
            self.published_url: {"tag_name": "v0.3.0", "target_commitish": self.source,
                                 "immutable": True, "draft": False, "prerelease": False},
            self.api + "/git/ref/tags/v0.3.0": {"object": {"type": "tag", "sha": self.tag}},
            self.api + "/git/tags/" + self.tag: {"tag": "v0.3.0", "sha": self.tag,
                                                  "object": {"type": "commit", "sha": self.source}},
            self.api + "/git/commits/" + self.source: {"sha": self.source, "tree": {"sha": self.tree}},
            self.receipt_url: self.receipt, self.marker_url: self.marker,
        }
        self.search_url = promotion.release.API_URL + "declarations/declaration-data.bmp"
        records = {}
        locations = []
        raw = f"https://raw.githubusercontent.com/serhatemrecoban/LeanInfoTheory/{self.source}/"
        for name, module in promotion.R3_ENDPOINTS.items():
            stem = module.replace(".", "/")
            records[name] = {"docLink": f"./{stem}.html#{name}"}
            short = name.rsplit(".", 1)[-1]
            locations.append({"name": name, "module": module, "path": stem + ".lean", "line": 6, "short_name": short})
            self.public[raw + stem + ".lean"] = "\n" * 5 + f"theorem {short} : True := by\n  trivial\n\n"
            source_url = f"https://github.com/serhatemrecoban/LeanInfoTheory/blob/{self.source}/{stem}.lean#L5-L8"
            self.public[promotion.release.API_URL + stem + ".html"] = (
                f'<div class="decl" id="{name}"><div class="decl_header">theorem'
                '<div class="decl_type">True</div></div>'
                f'<div class="gh_link"><a href="{source_url}">source</a></div></div>')
        self.public[self.search_url] = {"declarations": records}
        self.public[raw + "home_page/docs/declaration_index.json"] = {"declarations": locations}

    def resolve(self, site="main"):
        def read(url):
            value = self.public[url]
            return value.encode() if isinstance(value, str) else encode(value)
        return promotion.resolve(site, self.pins, read)

    def test_api_can_precede_its_live_marker_but_main_requires_the_marker(self):
        del self.public[self.marker_url]
        self.assertEqual(self.resolve("api")["bundle_url"], self.base + "/api.zip")
        with self.assertRaises(KeyError):
            self.resolve("main")
        self.public[self.marker_url] = self.marker
        self.assertEqual(self.resolve("main")["tar_sha256"], self.pins["archives"]["main"]["tar_sha256"])

    def test_public_release_and_annotated_tag_must_match(self):
        for key, value in (("immutable", False), ("draft", True), ("prerelease", True),
                           ("tag_name", "v0.2.0"), ("target_commitish", self.tree)):
            with self.subTest(key=key):
                release = self.public[self.published_url]
                old = release[key]
                release[key] = value
                with self.assertRaisesRegex(ValueError, "immutable release"):
                    self.resolve("api")
                release[key] = old
        self.public[self.api + "/git/tags/" + self.tag]["object"]["sha"] = self.tree
        with self.assertRaisesRegex(ValueError, "annotated tag"):
            self.resolve()

    def test_refuse_changed_receipt_and_rehearsal_even_if_pinned(self):
        self.receipt["purpose"] = "rehearsal"
        with self.assertRaisesRegex(ValueError, "reviewed artifact"):
            self.resolve()
        self.pins["receipt_sha256"] = sha(encode(self.receipt))
        with self.assertRaisesRegex(ValueError, "exact candidate"):
            self.resolve()

    def test_main_refuses_stale_marker_and_inconsistent_attestation(self):
        self.marker["source_identity"] = self.tree
        with self.assertRaisesRegex(ValueError, "qualified bytes"):
            self.resolve()
        self.receipt["api_stage_sha256"] = sha(encode(self.marker))
        self.pins["receipt_sha256"] = sha(encode(self.receipt))
        with self.assertRaisesRegex(ValueError, "different documentation or source"):
            self.resolve()

    def test_main_requires_search_signature_and_source_on_live_api(self):
        name, module = next(iter(promotion.R3_ENDPOINTS.items()))
        page = promotion.release.API_URL + module.replace(".", "/") + ".html"
        original = self.public[page]
        self.public[page] = original.replace(self.source, self.tree)
        with self.assertRaisesRegex(ValueError, "incorrect live source"):
            self.resolve()
        self.public[page] = original.replace("#L5-L8", "#L1-L2")
        with self.assertRaisesRegex(ValueError, "incorrect live source"):
            self.resolve()
        self.public[page] = original.replace('class="decl_type"', 'class="other"')
        with self.assertRaisesRegex(ValueError, "missing live theorem"):
            self.resolve()
        self.public[self.search_url]["declarations"][name]["docLink"] = "./other.html"
        with self.assertRaisesRegex(ValueError, "live search index"):
            self.resolve()


if __name__ == "__main__":
    unittest.main()
