# Strategy + proof: division-algebra dimension selection (Conjecture N) — why d = 4

## Context (blind to the wider repo)

A finite null-edge program has mass = null-direction disagreement `det P = Σ|ψ_i∧ψ_j|²`,
stated over ℂ. It secretly lives at d=4 because `2×2` Hermitian matrices over the
division algebras K = R, C, H, O ARE Minkowski space in d = 3, 4, 6, 10 (Baez–Huerta,
Sudbery, Manogue–Dray, all [import]); null vectors are rank-one `ψψ†`; `SL(2,K)` gives
the Lorentz groups. So the Plücker mass identity generalizes to a **four-member family**,
and dimension selection = which member supports the rest of the framework.

## Your task (strategy + proof)

Prove the discriminators that force K = C (d = 4):

1. **The wedge phase discriminator.** Formalize the two-spinor bracket / wedge over each
   K and prove: over R the wedge is real (CP is a sign, no continuous phase — the
   Bargmann/CP holonomy is unformulable); over H the "phase" is a noncommutative Sp(1)
   holonomy (Bargmann triples lose cyclic/order-independent well-definedness); over O
   the associator obstructs the triple product. Only C gives a **continuous, abelian,
   order-independent CP phase**. Prove the C-uniqueness of a well-defined cyclic
   Bargmann triple among R, C, H (the O associator obstruction can be a separate lemma).
2. **The composition discriminator.** Mass monogamy and the Fock layer need **tensor
   products** of direction registers; prove/cite that quaternionic and octonionic
   quantum theory lack a tensor product (no bilinear ⊗ over a noncommutative/nonassoc
   division algebra), while R and C have it.
3. **Assemble:** composition (multi-particle systems exist) + continuous abelian CP
   phase (CP violation is measured) **jointly force K = C, hence d = 4**. State this as
   the two-premise selection theorem; both premises are physical, both discriminators
   finite-checkable.

Kill: a workable quaternionic Bargmann invariant WITH tensor composition. Bonus: the
`3×3` octonionic case is the exceptional Jordan algebra (the three-generation locale) —
the d=10 member's failure mode is plausibly where the family index (Conjecture C) lives,
NOT d=4.

## Constraints
Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, in-file `#print axioms`. Mathlib
only (search for existing division-algebra / composition-algebra API). Deliver Lean +
`ARISTOTLE_SUMMARY.md`: the wedge-phase and composition discriminators proved over each
K as far as they land, the d=4 selection statement, and an honest boundary.
