# Incident log

## INC-2026-07-12-LEASE-RACE

- Date: 2026-07-12
- Severity: contained process-integrity incident
- Affected artifact: `state/FILE_LEASES.json`
- Detection: three parallel `labctl.py lease` calls produced concatenated JSON;
  the next registry read failed with `JSONDecodeError: Extra data`.
- Impact: no scientific source was overwritten. One of three requested leases
  was recorded, two failed, and state validation was temporarily unavailable.
- Containment: preserved the two valid pre-existing lease records, removed the
  trailing fragment, validated the registry, and reacquired the missing leases
  sequentially.
- Root cause: each process used the same temporary filename and performed an
  unlocked read-modify-write transaction.
- Preventive action: JSON temporary files now include the process ID; lease
  transactions use an atomic directory lock with timeout and stale-lock
  recovery; a concurrent-write regression test asserts that both writes
  survive.
- Scientific disposition: none. This incident concerns coordination state only.

Use `templates/INCIDENT_REPORT.md`. External model outages are blockers unless
they cause state corruption, uncontrolled action, false promotion, or data loss.
