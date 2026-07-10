# Aristotle job: fermion-doubling audit (Brillouin zone)

Date: 2026-07-10 morning (audience-question wave). The QW/QCA audience's
first technical question (NULL-EDGE_TARGET_AUDIENCE.md Q5): doubling and
extra cones across the full Brillouin zone. This proves the honest audit for
the landed exact dispersion cos(omega) = cos(k) cos(mu): the massless walk
has EXACTLY two gapless quasimomenta - the k=0 Dirac cone (U = 1, quasienergy
0) and the k=pi DOUBLER (U = -1, quasienergy pi: the pi-mode; doubling is
relocated, not evaded); one mass gaps both cones across the whole zone with
the uniform discriminant bound 4(1 - cos^2 mu); both massless branches
exactly luminal. Honest scope: doubling audit of THIS 1+1 split-step walk,
not Nielsen-Ninomiya, not 3+1.

```yaml
aristotle:
  project_id: e7f8ed51-d073-41ea-8b42-86a4c2cc79ef
  target_file: AgentTasks/aristotle-standalone/fermion-doubling-audit-20260710/FermionDoublingAudit/BrillouinZone.lean
  expected_module: FermionDoublingAudit.BrillouinZone
  submission_project: AgentTasks/aristotle-submit/claude-fermion-doubling-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/e7f8ed51-d073-41ea-8b42-86a4c2cc79ef
  status: complete-with-errors remotely; all returned declarations pass locally and are integrated
```

Local semantic correction: the `k=pi`, quasienergy-`pi` band touching is named
`pi_mode_partner`, not a second zero-energy doubler. Following Gupta--Short
(arXiv:2601.15885), the manuscript treats it as a Floquet pseudo-doubler. The
exact `{0,pi}` classification and massive discriminant bound are guarded in
`PhysicsSM/Draft/NullEdge/FermionDoublingAudit.lean`.
