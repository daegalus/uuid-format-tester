"""Preserve module MIME types and revalidate Flutter's unversioned bundles."""
import json
import os
import urllib.request

PULL_ZONE_ID = 3390951


def api(path, method="GET", payload=None):
    headers = {"AccessKey": os.environ["BUNNYNET_API_KEY"], "Accept": "application/json"}
    data = None
    if payload is not None:
        data = json.dumps(payload).encode()
        headers["Content-Type"] = "application/json"
    request = urllib.request.Request("https://api.bunny.net/" + path, data=data, headers=headers, method=method)
    with urllib.request.urlopen(request, timeout=45) as response:
        body = response.read()
        return json.loads(body) if body else None


def configure():
    path = f"pullzone/{PULL_ZONE_ID}"
    zone = api(path)
    assert zone["Name"] == "uuidformattester", "Unexpected pull zone"
    rules = [
        {
            "Description": "Flutter: JavaScript module content type",
            "ActionType": 5,
            "ActionParameter1": "Content-Type",
            "ActionParameter2": "text/javascript; charset=utf-8",
            "OrderIndex": 10000,
            "Triggers": [{"Type": 3, "PatternMatches": ["mjs"], "PatternMatchingType": 0}],
        },
        {
            "Description": "Flutter: revalidate unversioned application files",
            "ActionType": 16,
            "ActionParameter1": "0",
            "OrderIndex": 10001,
            "Triggers": [{"Type": 0, "PatternMatches": ["*"], "PatternMatchingType": 0}],
        },
    ]
    for rule in rules:
        existing = next((item for item in zone["EdgeRules"] if item.get("Description") == rule["Description"]), {})
        if existing.get("Guid"):
            rule["Guid"] = existing["Guid"]
        rule.update(Enabled=True, TriggerMatchingType=0)
        api(path + "/edgerules/addOrUpdate", "POST", rule)
    api(path + "/purgeCache", "POST")
    print("Flutter MIME and browser revalidation rules applied.")


if __name__ == "__main__":
    configure()
