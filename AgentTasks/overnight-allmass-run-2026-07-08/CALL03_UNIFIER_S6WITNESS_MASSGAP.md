# Fable call-03: the equivariant-index unifier, the S6 singlet witness, the mass-functional gap

Full log: `AgentTasks/model-calls/claude/2026-07-08-004503-fable-call-03.md`.

## Part A: the organizing theorem (equivariant graded index; 3-of-4 unification)

A single finite framework of which McKean-Singer protection, the C4 sectored
pinning, and the S1-CC balanced inertia are LITERAL corollaries. RG-Schur is
NOT an instance (a quantitative pairing law, not a deformation-invariant
integer) but attaches via a bridge. Master object: the equivariant supertrace
`tr(Gamma g | sector)` where the chirality Gamma, the closure bivector
`b = sigma_z (x) 1`, and the GW edge-reversal grading are all ODD elements of
ONE group; gauge + the reflection R are EVEN. (In the code `b` and the witness
grading `GammaW` are LITERALLY the same matrix sigma_z - that is the framework.)

Master conclusions: (i) an odd element preserving P => charpoly negation
-symmetric (=> n_+=n_- Hermitian / det=±1 multiplicative); (ii) an odd
involution Gamma => the Lefschetz supertrace tr(Gamma g|_P) localizes to
ker X (g=1 gives the index = graded dim); (iii) sector pinning
(dim ker(W∓1)∩V_chi >= |nu(chi)|), half-winding value = Lefschetz
fixed-point count ±(1/4)tr(Gamma R).

Lean design (new file `Carrier/EquivariantGradedIndex.lean`):
- L1 `anticonj_charpoly_eq` - LANDED (M).
- L2 `balanced_inertia_of_anticonj` - M-target (call-02 Part A route + Codex
  card_pos_eq_card_neg).
- L3 `graded_supertrace_localizes_to_kernel` - M-target, NEW: for Hermitian X,
  Gamma X Gamma = -X, [g,X]=[g,Gamma]=0 => tr(Gamma g) = tr((Gamma g)|_{ker X}).
  Re-derives the index protection family. Proof: eigenspace decomp; Gamma maps
  E_lambda -> E_{-lambda}; off-kernel cancels in pairs.
- L4 `sector_involution_pinning` - M-target (C4 spec).
- L5 `schur_complement_preserves_sector_index` - the RG-Schur bridge, C until
  hypotheses witnessed (vacuity risk).

## Part B: the S6 color-singlet mass-budget witness (concrete, rational, verified)

**No-go that shapes it (`singlet_one_leg_closure_zero`, M-target):** a
single-fiber singlet gives b_C = 0 for ANY transports (multiplicity-one =>
Schur => invariant ops act as scalars; one-leg background => singlet
expectation = normalized trace => kills K). So b_C != 0 REQUIRES the singlet
to stretch over a non-flat holonomy loop - the closure share of a singlet IS a
difference of Wilson loops.

**The witness (all rational, oracle-verified this call):**
- Space V = C^2 (x) (C^3 (x) C^3-bar), dim 18 (spinor (x) quark (x) antiquark).
- gamma1 = E01 (x) 1_9, gamma2 = E10 (x) 1_9; g = !![0,1;1,0].
- Gamma = sigma_z (x) 1_9; phi = 1_18.
- Transports (3-4-5 rational rotations u=R_z, v=R_x, w=R_y):
  nabla1 = 1_2 (x) (u (x) 1_3), nabla2 = 1_2 (x) (v (x) w-bar).
  K = [nabla1,nabla2] = 1_2 (x) ([u,v] (x) w) != 0 => Q_C = 2 sigma_z (x) ([u,v](x)w) != 0.
- State psi = (1,0) (x) s, s = eps-singlet. ev = Hilbert <psi,.psi>.
- Budget (exact, via <s|A(x)B|s> = Tr(A B^T)):
  ev(Q_C) = 2 Tr([u,v]w^T) = -256/125 (a Wilson-loop difference);
  ev(Q_A) = 2 Tr((uv+vu)w^T) = 540/125; 4 ev(Q_T) = 12; M^2 = 1784/125.
  (b_A, b_C, b_T) = (135/446, -32/223, 375/446), sum = 1. b_C != 0 and NEGATIVE.
- Bonus (hyperfine!): spin-down flips the closure sign,
  (b_A,b_C,b_T) = (135/574, +32/287, 375/574), M^2(down)-M^2(up) = 512/125 > 0
  - a finite pi/rho-analog splitting by the chromomagnetic channel alone.
- Flat negative control: nabla2 = 1_2 (x) (v (x) v-bar) => ev(Q_C) = 0 exactly.

Convention traps (docstring all 5): (1) Lambda(C^3) vs C^3(x)C^3-bar (eps/Hodge
sign, Lambda^2(g)~g-bar only for det g=1); (2) XOR-Fano - strand-count only, no
octonion products (ConventionBridge); (3) Krein # vs Hilbert † (name the
functional; don't call ev(D^2) "the mass" - Part C); (4) real transports don't
probe 3 vs 3-bar (keep w† explicit); (5) proof route: Kronecker lemmas, eval
only 3x3 traces by norm_num, do NOT fin_cases 18x18.
Grade: budget = M-target (rational decide; oracle-verified => currently C with
kill "exact Lean arithmetic disagrees with (135/446,-32/223,375/446)").

## Part C: the weakest load-bearing link = the mass FUNCTIONAL

"Mass" appears with TWO non-identified meanings: S3 mass = det P (spectral,
trusted); S4+ mass = M^2 := 4 ev(D^2) (expectation of an operator square in a
CHOSEN state against a CHOSEN functional). Every downstream headline uses the
expectation meaning while borrowing the determinant meaning's prestige. A
referee: "an expectation of D^2 is a mass only at an eigenstate; on a Krein
space not variationally meaningful without positivity - so the four-channel
budget decomposes a QUADRATIC FUNCTIONAL, not a mass." Both S4 rails leave it
open.

Shoring theorem (`sector_ground_mass`, finite Rayleigh-Ritz keystone, M-target,
ripe now that aperture_dominance_pos landed): on a J-positive-definite sector P
where the aperture-dominance inequality holds for J.(Q_A+Q_C) with D
Krein-self-adjoint => D^#D|_P is diagonalizable, real spectrum >= c-kappa>0 in
the J-inner-product; M^2_spec := min spec = min ev; at a minimizer psi_0 the
signed budget decomposes M^2_spec. THEN ev(D^2) at the ground state IS a mass,
and the budget decomposes a genuine mass.

## Alignment flags (5)
1. `anticonj_trace_zero` docstring "Even-power form" mislabels k=0 ODD case
   (S1CCBalancedInertia.lean ~L92; Codex file - handoff).
2. manuscript S4: (1/2,0,1/2) is arithmetic consequence not a separate theorem
   - soften wording (FIXED this run).
3. `aperture_dominance_pos`: instantiation must feed the KREIN form J.(Q_A+Q_C)
   not bare blocks; c>0 is implied not hypothesized (docstring note).
4. `ChiralInvolution` omits Gamma^H=Gamma - add unitarity in the NEW
   EquivariantGradedIndex structure (sector integrality wants it), not retro.
5. manuscript S3/S6/S8 rows aligned; closure_current_square MEMO demotion correct.
