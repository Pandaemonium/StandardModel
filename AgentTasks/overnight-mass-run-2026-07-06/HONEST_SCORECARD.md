# Honest scorecard: distance to "the full origin of mass from null edges"

Snapshot 2026-07-06 (WIDE run). This is the honest, kernel-grounded status of the
program against the goal, organized by the grand-strategy's (job `6fecc7f5`)
minimal conjunction that would earn the headline. Every row states what is PROVED
(kernel-checked, standard axioms `[propext, Classical.choice, Quot.sound]`, unless
noted), what is MODELED (an explicit hypothesis, not derived), and what is OPEN.

## The honest headline we can support TODAY

> Three taxonomically-distinct, kernel-checked FINITE obstructions to null
> transport - matter/turn (T), gauge/closure (C), kinematic/aperture (A) - each
> instantiated on finite lattices/algebra, shown pairwise distinct AND
> independently realizable; PLUS a complete finite Z2-slab gauge gap chain and its
> Tomboulis-Yaffe area-law scaffold generalized to an abstract SU(N) twist system.

What we CANNOT yet say: "the SU(N) Yang-Mills mass gap", "the continuum origin of
mass", or "a single physical model carrying all four masses". Those require the
open items below.

## Minimal-conjunction scorecard

### (A) Aperture / kinematic mass - LANDED (iff)
- `NBodyAperture.nbody_aperture_massless_iff_collinear`: for any N future-null
  momenta, `minkowskiSq (Sum p_i) = 0` iff a single null direction. **The iff -
  the necessity direction is proved.** Nonnegativity + double-sum also proved.
- Sorry-free headline, guarded. (One documented draft `sorry` on an alternative
  upper-triangular presentation only.)

### (T) Turn / matter mass - PARTIAL (channel decomposition only; no-go OPEN)
- PROVED: `DoublingTurnPrice` - the finite, LOCAL, per-vertex spin-algebra
  channel decomposition of the Wilson vertex (Wilson term is chirality-even;
  `chiralEven_massVertexW = (m+r)*1`; `chiralEven_massVertexW_eq_zero_iff`). Plus
  the landed gamma5 mass-vertex split.
- NOT proved (red-team `521d1c86` downgrade): the TOPOLOGICAL Nielsen-Ninomiya
  no-go and the NECESSITY direction ("chiral symmetry => forced doubling").
  DoublingTurnPrice is NOT that; its `no_chiral_and_doubler_removal` reduces to
  `gamma_mu != 0`.
- OPEN (in progress, job `sm-nn-nogo`): the genuine finite N-N no-go = a
  discrete-Brillouin-torus signed-chirality-sum theorem (= 0), giving the honest
  necessity corollary.

### (C) Closure / gauge mass - Z2 CHAIN COMPLETE; nonabelian gate OPEN
- PROVED (Z2 slab, KP-crux-FREE): `SlabGapAssembly.slabGapAssembly` bundles RP
  (PSD transfer block) -> Hermitian/self-adjoint OS transfer -> strictly positive
  OS spectral gap -> explicit `-log(tanh beta)` -> vacuum separation ->
  EXPONENTIAL CLUSTERING `<= C*exp(-(n*gap))` (uniform in n). One finite theorem.
- PROVED: `CharacterExpansion` finite-group character orthogonality + the CORRECT
  NONABELIAN strong-coupling dominance `charCoeff_abs_le_dim_mul_trivCoeff`
  (`||c_R|| <= dim(R)*c_triv`, SU(2)/SU(3)-applicable; the abelian-only over-claim
  was caught + fixed).
- PROVED (scaffold): `TYAreaLaw` (Z2 Tomboulis-Yaffe area law, positive rate,
  tied to `osSpectralGap`) and `TYAreaLawSUN` (abstract SU(N) twist system,
  `tyBaseSUN_two_landed` proving Z2 is the N=2 shadow).
- MODELED (explicit hypotheses, NOT derived): the RP/Cauchy-Schwarz raw bound
  `hW : |W| <= 2*q^r`; the SU(N) twist-monotonicity `Z_le`; the identification of
  `Z, Z^[k]` with lattice partition functions.
- OPEN (THE SINGLE GATE): construct the actual SU(N) lattice Haar measure +
  twisted partition functions, DERIVE `hW`/`Z_le` from reflection positivity, and
  a proven positive rate for a genuinely NONABELIAN group. Continuum limit is a
  further, separate open problem (deliberately not claimed).

### (X) Taxonomy - LANDED (distinct AND non-degenerate)
- `MassTaxonomySeparation.massTaxonomy_functionals_pairwise_separated`: the four
  functionals are pairwise distinct.
- `MassTaxonomyNonDegeneracy.massTaxonomy_nondegenerate`: each is independently
  realizable on its own parameter domain (honest per-leg: regulator/aperture
  two-sided; closure only limit-zero; turn OFF-only). NOT a common-carrier claim.
- `AllMassFromNullEdges.allMassFromNullEdges_guarded`: the four obstructions +
  separation bundled as one guarded theorem.

### (V) Trust - LANDED
- Build-enforced axiom guards on every flagship (`SlabAxiomGuard`, the capstone
  guard, the embedded non-degeneracy guard). 4 kernel-checked VERIFIED NEGATIVES
  this run. E8-240 count + completeness DE-NATIVIZED (kernel-checked, standard
  axioms - no `native_decide`).

### (B) Division algebra -> SM - co-location only
- su(3) submonoid = SU(3), color triplet = fundamental, charge CO-LOCATION verdict
  (the SM charges sit where the algebra says). A genuine dynamical coupling beyond
  co-location is OPEN. Spin(10) stabilizer: transitivity sorry shown FALSE (4th
  verified negative); Iso false; Selector open.

## The one-line honest distance

The floor (A-iff, X-distinct+non-degenerate, V-guards, a complete finite Z2 gauge
gap chain, the nonabelian character-dominance, and the SU(N) TY scaffold) is
BANKED. The two remaining gates to the full ambitious headline are both honest and
explicit: **(C) a nonabelian positive-rate area law from a constructed SU(N)
lattice measure** (the single gate), and **(T) the genuine finite N-N no-go /
necessity** (in progress). Everything modeled-vs-proved is labeled at the theorem
level; no continuum or Clay-gap claim is made anywhere.
