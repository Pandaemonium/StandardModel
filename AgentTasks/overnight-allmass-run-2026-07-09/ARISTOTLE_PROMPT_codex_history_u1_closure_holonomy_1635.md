# Codex history U(1) closure holonomy, 2026-07-09 16:35

aristotle:
  project_id: 91343f7e-d1da-4e79-8227-ecbce9952bae
  target_file: HistoryClosure/U1HistoryClosureHolonomy.lean
  expected_module: HistoryClosure.U1HistoryClosureHolonomy
  submission_project: AgentTasks/aristotle-submit/codex-history-u1-closure-holonomy-20260709-1635-project
  output_dir: AgentTasks/aristotle-output/91343f7e-d1da-4e79-8227-ecbce9952bae
  status: submitted 2026-07-09 16:36 PDT

You are Aristotle. Extend the newly landed local checkerboard action from a
turn-only phase to its first genuinely nontrivial closure channel. Prove the
attached Mathlib-only target in full.

Target:

```text
HistoryClosure/U1HistoryClosureHolonomy.lean
```

Context pack:

```text
AgentTasks/context-packs/history-u1-closure-holonomy-20260709-1630-20260709-163241.md
```

## Required payload

1. Prove exact holonomy and endpoint composition under list concatenation.
2. Prove endpoint gauge covariance for open histories under unit complex
   vertex gauges.
3. Deduce gauge invariance for closed histories and multiplicativity of
   based closed loops.
4. Prove the exact `Fin 4` square fixture: the loop closes, the gauge is unit
   and nonidentity, and both original and transformed holonomies are exactly
   `I != 1`.
5. Strengthen the final verdict if necessary so it exposes composition, open
   covariance, closed invariance, and the nontrivial fixture. Add build-enforced
   axiom-footprint guard pins to every headline theorem.

Useful facts may include `map_mul`, `Complex.normSq_apply`,
`Complex.mul_conj`, associativity/commutativity in `Complex`, and induction on
the vertex tail. Preserve every mathematically valid statement; report and
repair any malformed one rather than silently weakening it.

## Scientific boundary and provenance

This is the finite U(1) closure phase missing from the four-channel history
program. It is not a nonabelian Wilson action, continuum gauge field, path
integral measure, or Yang-Mills limit. Full-text Neo4j search found the
quiver-holonomy/Wilson-loop construction in arXiv:2401.03705 and lattice-gauge
precedent in arXiv:1301.3480. Use those only for theorem shape; no external code
is imported.

Run first:

```text
lake env lean HistoryClosure/U1HistoryClosureHolonomy.lean
```
