# Null-edge program charter (post-audit, 2026-07-07)

Distilled from the Q03 no-go audit (`AgentTasks/fable_parallel/Q03_answer.md`),
with Q01 (positivity: Theorem A / finite Gupta-Bleuler) and Q02 (gravity slot:
invariance + corrected telescoping) integrated. This is the strongest
unification claim consistent with Coleman-Mandula, Weinberg-Witten (+ Marolf),
Nielsen-Ninomiya, and the Connes-axiom comparison - stated as a ladder of
claims with displayed gates and kill-conditions. Claim calculus as in the P1
manuscript (T / T|H / M / C; kills pre-registered).

## The one-sentence position

Coleman-Mandula closed unification-by-SYMMETRY in 1967; unification-by-
DECOMPOSITION is the door left open, and its toll is exactly the program's
already-registered open problems - physical-sector positivity, emergent
redundancy in the limit, and honest chirality descent. Nothing new is fatal;
nothing already-open is optional.

## Three amendments adopted (relative to the pre-audit maximal claim)

1. **No coupling-unification and no representation-content claims.** Those are
   consequences of NCG axioms (first-order condition + spectral action) that
   the carrier demonstrably does not satisfy; our gauge fields arise from
   holonomy, not inner fluctuations. Replacement axiom to be sought; its seed
   is the KERNEL color-commutant theorem. Never claim NCG-style coupling
   relations.
2. **Gravity is claimed only as follows:** a gapless spin-2 excitation of a
   constrained quotient possessing NO Lorentz-covariant conserved stress
   tensor, with emergent redundancy as a theorem OBLIGATION (WW/Marolf), not a
   bonus. Fallback shape if the obligation fails: Jacobson-style field
   equations without a graviton, or an honest gapped E-mode.
3. **Chirality is claimed only through Ginsparg-Wilson descent to the physical
   sector.** Retardedness is demoted from mechanism to regulator/orientation:
   it selects forward data and shapes which zeros are on-shell; it provably
   cannot delete doubling partners (null-homology of the retarded zero set).

## The claim ladder

**U0 (M, KERNEL - the floor).** One finite Krein carrier `D` on a decorated
2-complex satisfies `4 D^#D = Q_A^# + Q_C^# + 4 Q_T + 4 E_#`; `Q_A` = invariant
mass of the total null momentum; `ind(D) = dim M_+ - dim M_-` for all Hilbert-
and Krein-self-adjoint carriers; the kappa = 2 witness certifies non-vacuous
indefinite geometry (mass-form sector); the color commutant is scalar.

**U1 (C; gate: GLUE witness + finite Gupta-Bleuler (H*)).** For the GLUE model
class, the induced form on `V'/N` is positive definite and `N` equals the span
of the gauge directions - by Theorem A (Q01) this is the Witt-geometry
condition: the Gauss/closure covectors span a D-invariant maximal isotropic
subspace (isotropy + count = kappa + finite Ward identity `D Gamma' <= Gamma'`).
*Kill:* a GLUE model with radical != gauge span, indefinite induced form, or a
real-split constraint plane (the 2x2 trichotomy kill-condition). All spectral
language stays forbidden until U1 closes. U1 is simultaneously: the
Coleman-Mandula analyticity input, the Weinberg-Witten redundancy carrier, and
the Nielsen-Ninomiya unitarity payment - the audit's central finding is that
all three defenses land on this same square.

**U2 (C; the redundancy obligation - WW/Marolf).** In refinement families the
E-slot generates first-class constraints; on `V'/N` no covariant conserved
`T^{mu nu}` exists; the on-shell generator of evolution is cohomologically
(boundary-)supported (Marolf compliance; P9 harmonic-cohomology wiring).
*Kill:* a quotient with a covariant conserved stress tensor AND a gapless
spin-2 mode - then publish "the E-mode is gapped" and retreat to
Jacobson-shape claims.

**U3 (C; chirality descent - NN).** The quotient carrier satisfies a GW
relation whose Luescher symmetry carries index `ind(D)`; retarded zeros absent
from the unitary shell stay absent after the quotient. *Pre-registered:*
compute the zero set of the dispersion polynomial
`det sigma(k) = sum_{e<f} z_e z_f |psi_e wedge psi_f|^2` on the covers of
record. *Kill:* positive-dimensional gapless sets not removable by GW descent;
or any claimed `ind != 0` on a periodic cover (cover lemma; hypothesis note:
pin the per-cell balanced-grading/full-spinor-fiber assumption when
formalizing).

**U4 (T|H - the limit).** Emergent metric identity
`det sigma = -g(k,k) + O(k^3)` with
`g^{mu nu} = sum_{e<f} e^{(mu} f^{nu)} |psi_e wedge psi_f|^2` (wedge-weighted
soldering Gram - the doubling analysis, Layer K, and the E-slot metric in one
formula); Lorentz-violating operators irrelevant under the refinement flow
(hypothesis displayed). *Experimental kill:* SME / photon-dispersion bounds.

**U5 (C; factorization - CM as OUTPUT).** Every exact symmetry of the emergent
S-matrix factorizes as Poincare x compact internal; any complex symmetry mixing
soldering with internal decorations breaks, gauges, or trivializes on
asymptotic states. A derivation target: achieved, it would EXPLAIN the
factorization CM otherwise forces us to assume.

## Explicitly lost (say it in every outward-facing document)

- Coupling unification (NCG-style relations `g_3^2 = g_2^2 = (5/3) g_1^2`):
  not available to a holonomy-based gauge mechanism without the first-order
  condition.
- SM representation content as a derivation: pending a replacement decoration
  axiom (seed: the color-commutant theorem).
- Exact fundamental Lorentz invariance: emergent only; loophole (iii) at the
  finite level must land in loophole (ii) (diff-redundancy) in the limit.
- All spectral claims, pending U1.

## Standing terminology guard

The Krein fundamental symmetry `J` (linear, metric operator) and an NCG real
structure `J_R` (antilinear, charge conjugation) are DIFFERENT objects and
must never share notation. Candidate `J_R` = (edge-orientation reversal)
composed with antilinear conjugation; its sign table on the kappa = 2 witness
is an open cheap target (Q03 ladder L8).

## Provenance

Q01/Q02/Q03 memos: `AgentTasks/fable_parallel/Q0{1,2,3}_answer.md`
(Fable-5 parallel deep-work session, 2026-07-07; briefing:
`AgentTasks/twoday-carrier-run-2026-07-07/fable-parallel/00-PROJECT-INTRO.md`).
Executor verification pass (Claude, same date): Q01's O2/O3 counterexamples,
perp-signature arithmetic, 2x2 trichotomy, and F2 (definitizability vacuous)
hand-checked; Q02's P-probe (torsion = 0, positive drift, Gram 1 + cos theta)
hand-checked; Q03's dispersion-polynomial identity hand-checked; Q03's cover
lemma flagged for hypothesis-pinning. Literature identifiers marked
"unverified" in the memos remain unverified until pulled through the Neo4j
pipeline.
