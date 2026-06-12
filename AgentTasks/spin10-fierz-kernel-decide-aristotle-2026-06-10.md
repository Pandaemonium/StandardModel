# Aristotle task: kernel-clean Spin(10) Fierz enumeration

Date: 2026-06-10

## Goal

Eliminate the last `native_decide` from the Spin(10) Fierz development:
replace the compiled-evaluator proof of `fierzZ_symmetrized` in

```text
PhysicsSM/Draft/SpinorTenfoldFierzAristotle.lean
```

with a kernel-checkable proof (no `native_decide`, no `sorry`, no new axioms).
The statement must not be changed or weakened:

```lean
theorem fierzZ_symmetrized :
    ∀ S T U : Finset (Fin 5), S.card % 2 = 0 → T.card % 2 = 0 → U.card % 2 = 0 →
      cliffordActionZ (gBasisZ S T) (basisZ U)
        + cliffordActionZ (gBasisZ S U) (basisZ T)
        + cliffordActionZ (gBasisZ T S) (basisZ U)
        + cliffordActionZ (gBasisZ T U) (basisZ S)
        + cliffordActionZ (gBasisZ U S) (basisZ T)
        + cliffordActionZ (gBasisZ U T) (basisZ S) = 0
```

Everything downstream in that file (`fierz_clifford`,
`Q10_gammaBilinear_self_eq_zero`, `sharpMap_graph_eq_zero_of_even`) must keep
compiling. Once the file is `native_decide`-free it will be promoted to the
trusted tree.

## Background and prior work

This is the follow-up to job `198550bc-ef58-4789-bda2-b7361cc6c3f7`
(`AgentTasks/spin10-fierz-cayley-chart-aristotle-2026-06-09.md`). The
infrastructure was promoted to the trusted module

```text
PhysicsSM/Spinor/SpinorTenfoldGammaSymm.lean
```

which already contains, kernel-clean:

- the integer mirror `FockSpinorZ`, `wedgeZ`, `contractZ`, `chevalleyPairingZ`,
  `gammaBilinearZ`, `cliffordActionZ`,
- the closed form `gBasisZ` with at most one nonzero entry per half, and the
  *structural* proof `gBasisZ_eq : gBasisZ S T = gammaBilinearZ (basisZ S)
  (basisZ T)` (via the signed-indicator lemmas `wedgeZ_basisZ_of_not_mem`,
  `contractZ_basisZ_of_mem`, `chevalleyPairingZ_signedBasis_left`),
- the 32 x 32 symmetry `gBasisZ_symm` by plain kernel `decide` (fast),
- the CAR module `PhysicsSM/Spinor/SpinorTenfoldCAR.lean` with all
  anticommutation relations and the Clifford square relation.

## Suggested strategies

A direct kernel `decide` over all `32^3` triples is too slow (the
`cliffordActionZ` evaluations make it billions of kernel steps). Ideas, in
rough order of preference:

1. **Closed form for the cubic term.** `gBasisZ S T` has at most one nonzero
   index per half: the `a`-half needs `j ∈ S` with `(S.erase j)ᶜ = T` (forcing
   `|S| + |T| = 6` and `j` the unique element of `S \ Tᶜ`), the `b`-half needs
   `j ∉ S` with `(insert j S)ᶜ = T` (forcing `|S| + |T| = 4`). Hence
   `cliffordActionZ (gBasisZ S T) (basisZ U)` is a sum of at most two signed
   monomials `wedgeZ j (basisZ U)` / `contractZ j (basisZ U)`. Prove this as a
   structural lemma (the signed-indicator basis lemmas above do the work),
   then the six-term identity reduces to finitely many sign cancellations
   indexed by small intersection data, which `decide` or explicit case
   analysis can close per configuration.

2. **Cardinality-stratified decide.** Note the whole expression vanishes
   trivially unless the cardinalities match (`|S| + |T| ∈ {4, 6}` etc.).
   Splitting the statement into the few even-cardinality patterns
   `(|S|, |T|, |U|)` and deciding each stratum separately may bring each
   kernel check into feasible range.

3. **Structural symmetrized-gamma identity.** The mathematical content is the
   `D = 10` identity `Γ^a_{(αβ} Γ_{a γ)δ} = 0`. A fully structural proof via
   the duality `j ↔` complement (as in `gBasisZ_symm`) is acceptable but
   probably harder than 1 + 2.

Helper lemmas are welcome, either in the draft file or in a new file under
`PhysicsSM/Spinor/`. Do not change the definitions or sign conventions in
`SpinorTenfoldFock.lean`, `SpinorTenfoldPurity.lean`, or
`SpinorTenfoldGammaSymm.lean`. The identity is independently verified by
`Scripts/oracle/validate_spinor_tenfold.py` (exact rational arithmetic).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and **no `native_decide`**
  anywhere in the returned proof.
- Plain kernel `decide` is allowed where it is fast enough.
- Do not weaken the theorem statement.

## Verification

Run:

```bash
lake build PhysicsSM.Draft.SpinorTenfoldFierzAristotle
```

and check axioms:

```lean
#print axioms PhysicsSM.Draft.SpinorTenfoldFierzAristotle.fierz_clifford
-- must show only [propext, Classical.choice, Quot.sound]
```

## Submission

Status: submitted.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-fierz-kernel-20260610
```

Job ID:

```text
93e29d35-37f8-4c3c-bad7-02b5fca82612
```

## Outcome (2026-06-10)

Status: COMPLETE, integrated and promoted to trusted.

Aristotle implemented exactly suggested strategy 1: a closed form `termData`
showing `cliffordActionZ (gBasisZ S T) (basisZ U)` is a *single* signed wedge
monomial, proved correct structurally (`termData_eq`), then a kernel `decide`
(`cancel_all`, `maxHeartbeats 4000000`) over the cheap `(coeff, target)` data
for all even triples. It also sharpened the target: the kernel check proves
the *three-term* cyclic identity `fierzZ_three`; the six-term
`fierzZ_symmetrized` follows from it via the trusted symmetry `gBasisZ_symm`.
Result archive: `AgentTasks/aristotle-output/spin10-20260610/fierz-kernel`.

Integration notes:

- New trusted module `PhysicsSM/Spinor/SpinorTenfoldFierzKernel.lean`
  (closed form + kernel enumeration; verbatim, provenance added).
- The former draft was promoted to trusted
  `PhysicsSM/Spinor/SpinorTenfoldFierz.lean` (namespace
  `PhysicsSM.Spinor.SpinorTenfold`); the draft file
  `PhysicsSM/Draft/SpinorTenfoldFierzAristotle.lean` was retired and removed
  from `PhysicsSMDraft.lean`.
- Axiom audit (`Scripts/check_axioms_spin10.lean`): `fierz_clifford` and
  `sharpMap_graph_eq_zero_of_even` depend only on `propext`,
  `Classical.choice`, `Quot.sound`.
- Build cost note: the `cancel_all` kernel `decide` takes ~7 minutes on a
  clean rebuild of the module (cached in the olean afterwards). A cheaper or
  fully structural replacement is a possible future cleanup; candidate routes
  are recorded in `EXECUTION_PLAN.md` (Baez-Huerta octonionic alternativity
  proof, or `Hom(Sym^3 S+, S-) = 0` representation theory).
