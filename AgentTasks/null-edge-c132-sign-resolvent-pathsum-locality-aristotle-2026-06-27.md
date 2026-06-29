---
aristotle:
  project_id: pending
  task_id: pending
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project
  output_dir: pending
  status: held_due_to_aristotle_concurrency_limit
---

# C132 Aristotle job: sign/resolvent path-sum locality

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a theorem-design job. Do not build the full repo.

Goal:

Design the non-ultralocal control theorem for `sign(H_ne)` using a
sign/resolvent/path-sum representation.

Starting point:

```text
sign(H) = (2 / pi) integral_0^infty H (H^2 + s^2)^-1 ds
```

or a finite rational/polynomial approximation suitable for formalization.

Task:

1. Give a finite-volume resolvent expansion for `(H^2 + s^2)^-1`.
2. Interpret matrix elements as null-edge path sums.
3. State shell-growth and amplitude-decay conditions under which the sign
   kernel is controlled.
4. Explain when this gives exponential decay as a sufficient theorem.
5. State a weaker controlled non-ultralocal theorem if exponential decay is too
   strong.
6. Add gauge covariance:

```text
H(U^g) = rho(g) H(U) rho(g)^-1
=> sign(H(U^g)) = rho(g) sign(H(U)) rho(g)^-1.
```

7. State how this supports the null-edge overlap program without claiming a full
   anomaly-complete chiral gauge theory.

## Submission note

Held on 2026-06-27 because Aristotle hit the in-progress project limit while
submitting the null-edge overlap program round. Submit this after C131 once the
queue has capacity.
