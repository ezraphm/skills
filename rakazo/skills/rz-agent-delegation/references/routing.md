# Rakazo routing reference

Source baseline: commit `6c7e1bcc6a44156295b01d4af32d1c1ddcec5418`.
Deployment version remains unknown. Runtime tools/schema take precedence over this reference.

| Context | Expected at source baseline | Action |
|---|---|---|
| Direct thread | message_bot eligible subject to run filters | request for work, result for return |
| Group thread | message_bot filtered | handoff distinct stage; post result in shared thread |
| Outside group handoff | group_id required | Destination is group, not private DM |
| Reverse handoff to current stage sender | blocked | Do not bounce ownership merely to report |
| Background run | messaging excluded by run selection | Do not plan unavailable messaging |
| Created run | ask_user/update_bot only | No delegation |
| Bot-message callback run | not owner-started fleet-management context | Do not require list_fleet |
| find_tool unknown | No match in deferred offered set | Also inspect listed tools; not proof tool absent globally |

message_bot schema intent: request | result | question | status | fyi.
"task" is not an allowed intent. Writing @Name in bot output is not a verified return mechanism.

Source:
- [selection](https://github.com/elie222/rakazo/blob/6c7e1bcc6a44156295b01d4af32d1c1ddcec5418/packages/adapters/src/run-tool-selection.ts)
- [thread filter](https://github.com/elie222/rakazo/blob/6c7e1bcc6a44156295b01d4af32d1c1ddcec5418/packages/adapters/src/schedule-tools.ts)
- [discovery](https://github.com/elie222/rakazo/blob/6c7e1bcc6a44156295b01d4af32d1c1ddcec5418/packages/adapters/src/builtin-tool-bridge.ts)
- [schema](https://github.com/elie222/rakazo/blob/6c7e1bcc6a44156295b01d4af32d1c1ddcec5418/packages/adapters/src/builtin-tools.ts)
- [group guard](https://github.com/elie222/rakazo/blob/6c7e1bcc6a44156295b01d4af32d1c1ddcec5418/packages/adapters/src/group-handoff.ts)
- [fleet run eligibility](https://rakazo.com/docs/fleet-management/)

Read this as source/documented behavior, not evidence a historical runtime test ran.
