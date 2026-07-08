# S1 advance: the nonabelian closure slot is an exact Krein square — and the crux relocates

Date: 2026-07-07 (late). Status: ORACLE-BACKED analytic advance on roadmap
stage S1 (handoff piece 3). Claim calculus: `T` source-verified, `M`
machine-verified program-internal, `O` oracle-pinned numeric (not proof),
`C` pre-registered conjecture, `[import]` external input.
Companion artifacts: `probe_s1_closure_oracle_v01.py` (24/24 PASS, seed
20260707) + robustness sweep (N ∈ {3,4,5}, random covector pairs, Haar
SU(2); worst residuals 2.8e-15) + `s1_oracle_run.log`.

TRANSCRIPTION RISK, stated first: all operator statements below are proven
in the oracle's conventions (2+1 Clifford, η = diag(+,−,−), J = γ⁰,
∇_μ = (S_μ − S_μ†)/2 so ∇^♯ = −∇ and D^♯ = −D; normalization D^♯D =
Q_A + Q_C, not the guard-pinned 4D^♯D = Q_A^♯ + Q_C^♯ + 4Q_T + 4E_♯).
The transcription is validated against four program pins (Weitzenböck
bookkeeping R2.3, commutator-equals-defect R2.5, flatness ⟺ Q_C = 0 R3.1,
P-iv aperture spectrum R7.1), but the identities must be re-derived
against the Lean definitions before any of this is claimed at grade `M`.

## 0. Verdict block

**V1 — Outcome (a) HOLDS, with an explicit current, on the two-transport
carrier.** On the class {Z_N² torus, two covariant transports, constant
null soldering (α₁, α₂), Φ = 0, any compact gauge group}, the Weitzenböck
closure slot Q_C = −b ⊗ K (b = ½[c(α₁), c(α₂)], K = [∇₁, ∇₂]) satisfies

```
Q_C = L^♯ L,      L = c(α₁) ⊗ 1  +  c(α₂) ⊗ (−K/2),
```

exactly, as finite operator algebra (proof: Finding F4, four lines;
oracle residual 2e-15 across all sweeps). The full solution set of the
two-term null-soldered ansatz is the GL-torsor
{L_A = c(α₁)⊗A + c(α₂)⊗B : A invertible, B = (A†)⁻¹(−K/2)}, with the
representation-invariant content pinned to A†B = −K/2. L is
gauge-covariant and two-hop quasi-local; the 1↔2 asymmetry is
representation gauge. Grade: `T` (finite algebra) + `O`; Lean target L4.

**V2 — But the pre-registered trichotomy (a)/(b)/(c) conflated
*representation* with *positivity*, and the honest crux relocates.** In a
Krein space, squares are cheap precisely where the program lives: null
Clifford coefficients are ♯-isotropic (c(α)^♯c(α) = c(α)² = 0), so
null-soldered squares carry no PSD diagonal — that is the same mechanism
as the carrier's own zero-diagonal theorem. Accordingly the oracle finds
sig(J Q_C) = (+18, −18) on the full space: **the closure form is
maximally indefinite globally even though it is an exact ♯-square.**
Positivity was never going to be a full-space fact. What V1 buys is the
exact reduction of S1 to the slot-descent hypothesis (the S0 lemma from
the Q5a session): if some member L_A preserves Γ′ and V′, then
[ψ, Q_C ψ] = [L_A ψ, L_A ψ] ≥ 0 on V′/N given T-I. **New gate S1-CC
(constraint compatibility), replacing the old trichotomy:** does the
GL-torsor intersect the constraint-compatible covariant operators? This
is now the entire content of closure positivity, and it lives at the Q01
interface, as the roadmap's outcome-(c) reroute anticipated — but with an
explicit family in hand rather than a defeat.

**V3 — LOUD FLAG: the registered S-C candidate is dead, for grading
reasons, and should be retired from the ledger.** The candidate
`Q_C = Σ_p M_p^♯ M_p, M_p = 1 − U_p` (site-diagonal Gram of plaquette
defects) cannot equal Q_C for any dressing or normalization: Q_C is
**purely off-diagonal in the site grading** (support only on hops
±(1,1), ±(1,−1); oracle R4.1, exact zero across all sweeps), while every
site-diagonal Gram is Frobenius-orthogonal to it (R4.2:
⟨Q_C, G⟩_F = 0.0). The failure is structural (displacement bookkeeping),
not quantitative, so no coefficient tuning rescues it. The defect Gram is
a *different, legitimate object* — see V4 — it just is not the
Weitzenböck slot.

**V4 — Physical-reading correction, propagating to S3/S6 wording.** The
per-face closure defect splits exactly (Finding F1):

```
1 − W  =  ½(1 − W)(1 − W)†  +  ½(W† − W)
        =  [Gram / energy-shaped, Herm, ~ a⁴|F|²]  +  [field-strength, skew, ~ a²F]
```

(oracle slopes 1.999 and 0.998). Q_C, being commutator-born, is **linear
in the defect**: its continuum shadow is the Lichnerowicz spin-curvature
coupling σ·F — the *chromomagnetic* operator — not the |F|² energy
density. Consequences: (i) the roadmap's S1 note "|1 − hol|² ~ |F|² —
closure disagreement IS gauge-field energy" is true of the defect Gram
but is NOT a statement about Q_C; the two must not be conflated in S3/S6
prose. (ii) In the S6 mass-budget theorem, ⟨Q_C⟩ is the **hyperfine
share**: its physical calibration targets are the Δ–N and ρ–π splittings
(De Rújula–Georgi–Glashow chromomagnetic phenomenology `[import]`), not
"99% of the proton mass". This *sharpens* the flagship — the budget
acquires a falsifiable spin-splitting row — while the bulk gluon-energy
share must enter through gauge-sector dynamics (S5 transfer/Wilson
action, where the defect Gram lives) or the trace-anomaly channel, not
through the fermion-bilinear Weitzenböck identity alone. Grade: split
identity `T` (one line); continuum reading `T|H` (Lichnerowicz
`[import]`); S6 wording change: recommended, pre-register before drafting.

**V5 — The indefiniteness is load-bearing for P-CHI, so stop treating it
as the failure branch.** Banks-Casher needs eigenvalue accumulation of
the Euclidean-side operator near zero; since the covariant-Laplacian part
is PSD there, the *only* term that can pull eigenvalues down is the
curvature/closure term, which therefore must have negative directions on
index-carrying backgrounds (continuum Lichnerowicz + index theorem
`[import]`). A Hilbert-PSD closure slot would have killed S4 outright.
Re-ranking: outcome-(c)-shaped global structure is *required by the
physics of chiral symmetry breaking*, and V1's sector-descent square is
how positivity on the physical sector coexists with it. S1 and S4 are now
coupled in the right direction.

**V6 — SU(2) understates SU(3) on exactly one axis.** The per-face
centrality (1−U)(1−U)† = (2 − tr U)·1 is SU(2) Cayley–Hamilton
(pseudoreality); it fails for SU(3) (oracle R1.3, distance 2.08 from
scalar). But F2–F4 use only skewness of K and Clifford nilpotency, so
**the square representation and the grading obstruction are
group-independent**, SU(3) included. Only Gram-side simplifications are
SU(2) luxuries.

## 1. Findings, with proofs

**F1 (per-face split + SU(2) centrality). `T`, Aristotle-ready.** For
unitary W: (1−W)(1−W)† = 2 − W − W†, and ½(1−W)(1−W)† + ½(W†−W) =
1 − ½W − ½W† + ½W† − ½W = 1 − W. For W ∈ SU(2), Cayley–Hamilton gives
W + W† = (tr W)·1, so (1−W)(1−W)† = (2 − tr W)·1 = 4 sin²(θ_W/2)·1 with
θ_W the holonomy rotation angle. *Observation (aperture rhyme):* the
per-face closure Gram 4 sin²(θ_W/2) has the same functional form as the
kernel-pinned two-edge aperture mass 4E² sin²(θ/2) — both channels are
the identical 1−cos obstruction, the angle living in the fiber for
closure and in the base for aperture. Pretty; grade as observation.

**F2 (null-soldered square lemma). `T`.** For L = c(α₁)⊗A + c(α₂)⊗B with
α₁, α₂ null: the diagonal blocks c(αᵢ)²⊗Aᵢ†Aᵢ vanish by nilpotency, and

```
L^♯L = g(α₁,α₂) ⊗ (A†B + B†A)  +  b ⊗ (A†B − B†A).
```

Every null-soldered square is (aperture-shaped sym) + (bivector antisym),
with no PSD diagonal — squares in this calculus are structurally shaped
like D^♯D itself, which is why representation existence and form
positivity decouple (V2).

**F3 (grading obstruction). `T`.** K = [∇₁,∇₂] = ¼ Σ_{s,t=±} st
[S₁ˢ, S₂ᵗ]; each commutator is (dressed defect)×(shift) with net
displacement ±e₁±e₂ ≠ 0, so Q_C has zero site-diagonal component, while
any Σ_p M_p^♯M_p with site-local M_p is site-diagonal. Hence
⟨Q_C, Σ M_p^♯M_p⟩_F = 0: the registered candidate lives in a grading
sector Q_C does not touch. (Aside: this also explains why Z₂ closure
closed so cleanly — for Z₂, (1−u)² = 2(1−u), collapsing Gram onto defect,
a coincidence unavailable beyond Z₂.)

**F4 (representation theorem + classification). `T` on the two-transport
class.** Set X = A†B in F2. Matching L^♯L = −b⊗K requires
X − X† = −K and X + X† = 0; writing X = −K/2 + H with H Hermitian, the
sym equation forces H = 0, so **X = −K/2 exactly** (consistency: K skew ⇒
X skew ⇒ sym part auto-zero). Solutions: A invertible arbitrary,
B = (A†)⁻¹(−K/2); the base point A = 1 gives V1's L. Geometric reading:
the closure current couples a unit reference flow along α₁ to the
curvature flow along α₂. HONEST SCOPE: proven for the two-transport
carrier; with ≥3 transport directions, Q_C = −Σ_{μ<ν} b_{μν}⊗[∇_μ,∇_ν]
and a per-pair ansatz generates cross-pair sym contaminations —
pre-registered risk: the multi-direction theorem may take the compensated
form Q_C + (aperture-shaped correction) = L^♯L, reactivating a corrected
outcome (a′). Next Lean-ladder rung, not assumed.

**F5 (readings pinned).** Flatness ⟺ Q_C = 0 including
flat-but-topological configurations (commuting constant cycle holonomies
give Q_C = 0: the closure slot is blind to 't Hooft-flux / Wilson-line
sectors — consonant with the YM-lane winding-flux correction to the gap
definition). Weak-field: ‖Q_C‖ ~ ε¹ (field-strength), defect Gram ~ ε²
(energy). Flat carrier spectrum = Minkowski norm² of the soldered
sine-momentum, matching the P-iv aperture shape, with negative doubler
branches — sig(J D^♯D) = (+18, −18) even free, so sector restriction is
load-bearing program-wide, not a closure-slot peculiarity.

## 2. Updated S1 registration

- RETIRE: S-C candidate `Q_C = Σ_p M_p^♯M_p` (killed by F3, grading).
- RECORD: representation theorem F4 (`T`/`O`; grade `M` after Lean
  transcription) and the GL-torsor classification.
- NEW GATE **S1-CC**: transcribe Γ′, V′ from the Q01/HSTAR lane; decide
  whether some covariant member of the torsor satisfies L_A Γ′ ⊆ Γ′,
  L_A V′ ⊆ V′. Cheap necessary-condition probe, runnable the day V′ is
  transcribed: compute sig(J Q_C |_{V′}) numerically. **Kill condition:**
  if the restricted form is indefinite for the correct V′, no compatible
  L exists and closure positivity genuinely fails on the physical sector
  — the serious version of outcome (c). If PSD, S0 + F4 turn closure
  positivity into a compatibility lemma.
- S3/S6 WORDING RAIL (from V4): "closure share" in the budget theorem
  names the chromomagnetic/hyperfine channel; the |F|² energy share is
  the defect Gram and enters via the gauge sector. No outward-facing
  sentence may equate ⟨Q_C⟩ with "gluon field energy" as such.
- S4 LINKAGE (from V5): register "closure-slot global indefiniteness" as
  a *prerequisite* invariant for the Banks-Casher rung, not a defect.

## 3. Lean ladder (all finite algebra; L1–L3 are Aristotle-shaped now)

- **L1** SU(2) centrality via Cayley–Hamilton (Matrix.charpoly in
  Mathlib) + the 4 sin²(θ/2) evaluation.
- **L2** per-face split identity (one line, unitary W).
- **L3** null-soldered square lemma F2 on the program's Clifford/Krein
  API (needs only c(α)² = 0 and ♯ fixing generators).
- **L4** representation theorem F4 on the two-transport model class,
  stated against the guard-pinned normalization (carry the 4's and the
  ♯-vs-† caveat verbatim).
- **L5** grading obstruction F3 (displacement decomposition of K;
  orthogonality corollary killing site-diagonal candidates).
- **L6** (open) multi-direction extension with the pre-registered
  compensated form.

## 4. Literature anchors `[import]` (run pre-add existence check)

Lichnerowicz 1963 / standard Weitzenböck-Bochner for the σ·F reading;
Banks–Casher 1980 (already in roadmap §6); De Rújula–Georgi–Glashow,
Phys. Rev. D 12, 147 (1975) — chromomagnetic hyperfine splittings, the
new S6 calibration row; Ji 1995 (budget comparison, unchanged);
Aharonov–Casher 1979 (flux zero modes; anchor for the planned
index-fixture probe). Wilson 1974, Osterwalder–Seiler 1978 unchanged.

## 5. One-paragraph summary

The S1 crux, as pre-registered, dissolved into something sharper: the
nonabelian closure slot **is** an exact Krein square of an explicit,
gauge-covariant, quasi-local current — for any compact group — but Krein
squares carry no positivity by themselves (the program's own nilpotency
mechanism guarantees that), so the entire question compresses, via the
already-proven slot-descent lemma, into whether the GL-torsor of
representations meets the constraint-compatible operators (new gate
S1-CC, at the Q01 interface, with a one-day numeric kill probe once V′ is
transcribed). Along the way: the old site-diagonal Gram candidate is
structurally dead; the closure slot is chromomagnetic (hyperfine-shaped),
not energy-shaped, which rewrites the S6 budget's physical reading into a
*more* falsifiable one; and the slot's global indefiniteness is
promoted from failure mode to prerequisite — it is where chiral symmetry
breaking, and hence most of the mass of the visible universe, has to come
from on this architecture.
