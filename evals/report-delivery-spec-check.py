"""Static specification contract checks, NOT runtime or agent-behavior tests."""
from pathlib import Path
import json
s=Path('skills/report-to-cos/SKILL.md').read_text()
h=Path('skills/handoff-that-arrives/SKILL.md').read_text()
cases={
'positive receipt': ['ACKNOWLEDGED: Rosie explicitly acknowledges','exact task/stage','report message or digest'],
'ambiguous task': ['provisional local stage key','before closing delivery'],
'no-send-tool / anti-bounce': ['Never invent message_bot availability','Do not use a\nreport-only handoff bounce'],
'interrupted run / dead history': ['After interruption, reconcile accessible','If history/receipts are unavailable, record that gap'],
'duplicate retry': ['Same key reuses','changed content gets a new digest'],
'missing ACK': ['Missing ACK stays POSTED','existing\ncoordination cadence'],
'approval boundary': ['Runtime changes require separate approval','No new routine, automatic owner ping'],
}
for name,quotes in cases.items():
    for q in quotes: assert q in s, (name,q)
    print('PASS SPEC TEXT:',name,'|',repr(quotes))
assert 'actually exposed assignment tool IN THAT SAME TURN' in h
assert 'local file plus ls -l proves only RESULT_WRITTEN, not delivery' in h
assert json.loads(Path('plugin.json').read_text())['version']=='1.7.3'
print('PASS: assignment-tool requirement preserved; file is not delivery; manifest 1.7.3')
print('7/7 static contract cases; runtime and agent-behavior execution: UNAVAILABLE, NOT TESTED')
