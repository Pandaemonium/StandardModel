# Gate C1 C277: W_branch candidate generation

Date: 2026-06-29
Status: prepared for Aristotle submission.

## Purpose

Ask Aristotle to generate a concrete matrix-valued `W_branch(k)` candidate, not another high-level strategy note.

## Submission packet

- Submission project: `AgentTasks\aristotle-submit\gate-c1-c277-wbranch-candidate-generation-20260629`
- Prompt: `AgentTasks\aristotle-submit\gate-c1-c277-wbranch-candidate-generation-20260629\PROMPT.md`
- Pro prompt copy: `AgentTasks\null-edge-pro-wbranch-candidate-request-2026-06-29.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: c9b3f460-d0ab-4b97-9785-2a37261fb1f3
  task_id: 70f54f0c-3a73-4ae6-87a3-ac4e25145366
  target_file: W_branch candidate generation
  expected_module: none
  submission_project: AgentTasks\aristotle-submit\gate-c1-c277-wbranch-candidate-generation-20260629
  output_dir: AgentTasks/aristotle-output/c9b3f460-d0ab-4b97-9785-2a37261fb1f3
  status: queued
```

## Prompt

````text
You are Aristotle working on the PhysicsSM null-edge Standard Model project.

Blunt request: generate an actual candidate for W_branch(k). We do not need another broad strategy memo. We need one or more explicit matrix-valued branch-Wilson/flavored-mass candidates, with enough detail that Codex can implement the first finite branch-mass scan in Lean.

Project goal: build a Standard-Model-compatible chiral fermion release from discrete lightlike/null-edge steps, using a null-edge flavored overlap / Ginsparg-Wilson architecture.

Current architecture:

```text
K_branch(k) = a^{-1} (i Q(sin k) + W_branch(k))
H_branch(k) = gamma5 * K_branch(k)
eps(k)      = sign(H_branch(k))
D_ov(k)     = a^{-1} (1 + gamma5 eps(k))
```

Current proven/scaffolded Lean pieces included in this packet:

- `BranchWilsonSquareCore.lean`: proved abstract square/gap-transfer core for `K = a^{-1}(iQ + W)`. The decisive theorem transfers a sector gap of `W^2 + i[W,Q]` to an inverse-propagator gap for `K`, without assuming `[W,Q]=0`.
- `TetraBranchWilsonSymbol.lean`: concrete `BranchWilsonData`, `Kbranch`, `Hbranch`, scalar specialization, chirality audit predicates, and wrappers around the square/gap core.
- `TetraFlavoredOverlap.lean`: finite branch-mass window interface. A candidate should eventually instantiate `BranchMassScanWitness` or `FlavoredWilsonSearchSpec`.
- `PhysicalC1Criteria.lean`: physical C1 certificate target.
- C273-C276 notes: strategy says the missing object is a concrete matrix-valued, branch-sensitive, Adams/Creutz/staggered-Wilson-like `W_branch(k)`, not an origin projector.

Known constraints and traps:

1. Do not use scalar Wilson as the chiral selector. Scalar Wilson is only a C0/gap seed and lies in the commuting trap.
2. Do not release chirality from the origin fiber alone. The origin kernel is chirality-balanced; the release must be a global branch/Brillouin-zone index effect.
3. `W_branch(k)` must be Hermitian and suitable for a Hermitian overlap seed.
4. It must be non-scalar and not everywhere anticommuting with gamma5.
5. It should break the balance/taste symmetry on the retained island, not simply add odd-looking terms that vanish after the sign function.
6. It must be gauge-safe: act in branch/taste/spin structure, commute with the internal Standard Model gauge action, and not gauge the balance involution J.
7. The mirror branch must be removed by a true inverse-propagator gap, not a propagator zero.
8. If rank-4 spin/taste is insufficient, say so bluntly and give the minimal added flavor/taste dimension.

What we need you to produce:

1. A primary explicit candidate formula for `W_branch(k)`.
   - Give the finite basis/fiber you use: for example `Spin = Fin 2 x Fin 2`, `Fin 4`, or a minimal extension.
   - Give explicit matrices for gamma5, any branch/taste Pauli matrices, J, and the `T_A` or `M_AB` terms.
   - Give the scalar coefficient functions in terms of `sin(k A)`, `cos(k A)`, `1 - cos(k A)`, constants `r`, `rho`, `lambda`, `m0`, etc.
   - Specify whether the term is Adams-like, Creutz/Borici-like, staggered-Wilson-like, or a new finite-taste construction.

2. A branch-mass window test for that candidate.
   - List the branch labels/momenta you want scanned, preferably compatible with `TetraFlavoredOverlap.Branch := Fin 4 -> Bool` and `branchMomentum`.
   - Define the branch mass/sign function that Codex should implement.
   - Give the desired inequalities: target branch negative, all others positive.
   - Give candidate parameter values or a symbolic window, if possible.
   - Compute or outline the branch-mass table. If exact arithmetic is hard, provide a finite numerical table and the exact formulas to verify.

3. A gap-transfer target.
   - Identify the bad-sector compressor/projector `E = 1 - P` or the sector decomposition to use.
   - State what lower bound should be checked for `E * (W^2 + i[W,Q]) * E`.
   - Say how to connect this to `TetraBranchWilsonSymbol.Kbranch_badSector_gap`.

4. A nonzero-index / trap-escape check.
   - Explain why the retained island should have nonzero chiral index.
   - Identify which symmetry J is broken on the retained island.
   - Explain why `zero_index_commuting_trap` and `overlapIndex_eq_zero_of_anticomm` do not apply.

5. Lean implementation guidance.
   - Give exact new declarations Codex should add to `TetraFlavoredOverlap.lean` or a new candidate module.
   - If possible, provide Lean code snippets for the finite matrices and branch mass function.
   - If not possible, give a precise pseudocode/math implementation plan.

6. Backup candidates.
   - Give at least two alternatives if the primary candidate fails: one minimal flavor/taste extension, and one homotopy-to-reference overlap construction.
   - For each backup, state the decisive finite test.

7. Failure/no-go criteria.
   - Tell us exactly what finite scan result would kill the primary candidate.
   - Tell us whether failure means the rank-4 tetra seed is wrong, or only that the fiber/taste dimension is too small.

Output format:

- Primary W_branch candidate:
- Explicit matrices / fiber:
- Branch-mass table or formulas:
- Parameter window:
- Gap-transfer target:
- Trap-escape / nonzero-index explanation:
- Lean declarations to add:
- Backup candidates:
- Failure criteria:
- Exact next action for Codex:

Be concrete. If you cannot give a fully physical candidate, give the best finite witness candidate that could instantiate `BranchMassScanWitness`, and be explicit about what physical bridge remains.

````


## Submission result

Submitted on 2026-06-29.

```text
WARNING: Your project contains .lean files but no .lake folder.
Aristotle works better with access to your project's dependencies.
Did you forget to run `lake build`?

Project created: c9b3f460-d0ab-4b97-9785-2a37261fb1f3

```


## Task status check

2026-06-29: `aristotle tasks c9b3f460-d0ab-4b97-9785-2a37261fb1f3 --limit 5` reported task `70f54f0c-3a73-4ae6-87a3-ac4e25145366` as `QUEUED`.
