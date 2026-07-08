# Fable-5 call 07 (solo run): the dynamics-instantiation flagship + final completeness

You are the most capable mathematical-physics referee + Lean semantic-alignment
auditor on this program (finite, machine-verified: *mass is the obstruction to
coherent null transport*). Since your last review (call-06) I acted on all your
items (landed the carrier bridge `M6 = B(2,1) ⊕ B(2,-1)` in the kernel; regraded
the §4 reduction claim) and then closed the **one remaining open dynamics link**
you and I had both flagged. I need a semantic-alignment audit of that new Lean
flagship and a final completeness verdict.

## What changed since call-06 (the new kernel content)

Previously, the dynamics section §9a honestly flagged that `FiniteUnitaryEvolution`
proves *any sector isometry* conserves norm/energy, but that the concrete carrier's
time step actually *being* such an isometry was **open** (the "fire D2 on the T2
witness" target). That is now closed and kernel-checked (`CarrierUnitaryFlow`,
embedded verbatim via --source-file). The chain:

1. `hermitian_flow_mem_unitaryGroup` — for Hermitian `H` and real `t`, the flow
   `exp(-i t H)` is a unitary matrix (`∈ Matrix.unitaryGroup`).
2. `hermitian_flow_isometry` — that flow induces a `LinearIsometryEquiv` on
   `EuclideanSpace ℂ n` (a genuine norm-preserving sector isometry).
3. `carrierFlowStep` / `carrier_orbit_norm_conserved` — specializing `H` to the
   mass-gap block `MassGapWitness.B lam kappa`, the discrete evolution **orbit** of
   the real carrier conserves the sector norm (and `..._energy_conserved` for
   commuting observables). All **M**, guard-pinned to `[propext, Classical.choice,
   Quot.sound]`.

## Your semantic-alignment task — be adversarial

1. Is `carrier_orbit_norm_conserved` genuinely "the *carrier's* evolution conserves
   norm", or is it a vacuous/generic wrapper? Specifically: is `carrierFlowStep`
   actually the physical flow `exp(-i t B)` of the carrier block, or could it be a
   trivial isometry that would prove the same thing? Where does the real content
   live — in `hermitian_flow_isometry` deriving a genuine isometry from `B`, or is
   there a gap?
2. Is `EuclideanSpace ℂ (Fin 3)` the honest sector Hilbert space here? The flow is
   on the full `3×3` block `B(lam,kappa)`. Is there an over-claim in calling this
   "the carrier's evolution" when the physical positive sector / the `6×6`
   `B(λ,κ)⊕B(λ,-κ)` form (per the carrier bridge) is the real object — i.e. does
   the docstring/§9a claim more than "the flow of the `3×3` block `B` conserves
   norm"?
3. Any grade slip: is calling this "FiniteUnitaryEvolution fires on the actual
   carrier" earned by these theorems, or does it outrun what the kernel proves?
4. The honest caveat already in §9a: this is first-quantized, and the resolution of
   "Krein-unitary ≠ norm-unitary" is that the *physical sector* carries a genuine
   positive inner product on which the flow is norm-unitary. Is that resolution
   correct and non-circular?

Report any mismatch between the intended physics and the kernel statements, most
severe first. I am NOT asking you to check the (kernel-verified) proofs — only
whether the STATEMENTS are the intended mathematics.

## Final completeness verdict

The complete manuscript is embedded (via --source-file). With the mass-gap
flagship (call-06) and now this dynamics instantiation both landed and pinned, and
all your call-05/call-06 items actioned: **is the manuscript now finished as a
self-contained Markdown draft?** If not, give a short, concrete, ordered
"remaining to finish" list (each item closeable in one editing pass). Flag any
stale grade, internal inconsistency, or over-claim, most severe first — if none,
say so and say what you checked.

## Required output

- **Semantic-alignment verdict on `CarrierUnitaryFlow`** (3–6 sentences).
- **Manuscript completeness verdict** (3–5 sentences): finished or not; shortest path.
- **Ordered "remaining to finish" list** (if any), concrete + small.
- **Bottom line:** the 1–3 things (if any) between here and "done".

Be specific and technical; one sharp correct load-bearing criticism beats ten
generic ones. Report even if the news is that it is done.
