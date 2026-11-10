"""Validate actual Rakazo candidate structure and numerical fixtures; no behavioral certification."""
from pathlib import Path
import json
import re
import sys

root = Path(sys.argv[1])
manifest = json.loads((root / 'plugin.json').read_text())
assert manifest['$schema'] == 'https://agent-plugins.org/schemas/1.1.0/plugin.schema.json'
assert re.fullmatch(r'[a-z0-9]+(?:[.-][a-z0-9]+)*', manifest['name'])
assert 'skills' not in manifest, 'Filesystem inventory, not an unsupported allowlist'
expected = {'rz-agent-delegation', 'rz-result-reporting', 'rz-evidence-review',
            'rz-write-verification', 'rz-bot-spec', 'rz-context-management'}
entries = list((root / 'skills').glob('*/SKILL.md'))
assert {p.parent.name for p in entries} == expected
total = 0
for p in entries:
    s = p.read_text()
    front = re.match(r'---\n(.*?)\n---\n', s, re.S)
    assert front, p
    fields = dict(line.split(': ', 1) for line in front[1].splitlines())
    assert fields['name'] == p.parent.name
    assert 0 < len(fields['description']) <= 2000
    assert s.count('```') % 2 == 0, p
    companions = [x for x in p.parent.rglob('*') if x.is_file() and x != p]
    assert len(companions) <= 40
    assert sum(x.stat().st_size for x in companions) <= 400000
    for target in re.findall(r'\]\(([^)]+)\)', s):
        if '://' not in target:
            resolved = (p.parent / target).resolve()
            assert resolved.is_relative_to(p.parent.resolve()), (p, target)
            assert resolved.is_file(), (p, target)
for p in root.rglob('*'):
    if p.relative_to(root).parts[0] == 'evals' or p.name == '.DS_Store':
        continue  # Local evaluation files are not imported plugin components.
    assert not p.is_symlink(), p
    if p.is_file():
        assert p.suffix in {'.md', '.json'}, p
        assert p.stat().st_size <= 100000, p
        total += p.stat().st_size
assert total <= 4000000
assert len(list(root.rglob('SKILL.md'))) == 6
assert not (root / 'mcp.json').exists()
assert not any((root / p).exists() for p in ['agents', 'commands', 'rules', 'hooks', 'automations'])
print(f'PACKAGE PASS: {len(entries)} skills; relative references resolve; {total} bytes')

for rates, errors, failures, winner in [([400,350,250],[.01,.04,.08],38,2),
                                        ([600,300,100],[.02,.05,.10],37,1)]:
    values = [a*b for a,b in zip(rates, errors)]
    assert sum(values) == failures
    assert max(range(3), key=lambda i: values[i]) == winner
    assert sum(rates) == 1000
root_inflight = (1000/60)*(.7*.07+.3*.17)
held = (1000/60)*.1+(1000/60)*.08+(300/60)*.1
assert abs(root_inflight-5/3) < 1e-9
assert abs(held-3.5) < 1e-9
print('ORACLES PASS: weighted failures and distinct concurrency definitions')
print('Rakazo preview/import, skill activation and agent behavior: NOT TESTED')
