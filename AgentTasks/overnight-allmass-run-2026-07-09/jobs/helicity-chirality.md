# claude-helicity-chirality — massless: chirality = helicity; mass is what couples opposite helicities

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Companion to the "slowed-down light" line. For a MASSLESS fermion, chirality (gamma5 eigenvalue)
equals helicity (spin projection on momentum), and the two Weyl components are decoupled helicity
eigenstates each moving at c. Mass is precisely the term that couples opposite helicities (so a
massive fermion is not a helicity eigenstate). Prove the finite statement.

## The model (explicit 2x2 blocks -> 4x4; real or explicit-complex constants)

Momentum along a fixed axis; helicity operator `h = sigma_3` on each Weyl 2-spinor (eigenvalues
+-1). Chirality `gamma5 = diag(+1,+1,-1,-1)` (block +/-). Weyl kinetic symbols `KL, KR` at the
chosen momentum. Massless Dirac `D0 = [[0, KR],[KL, 0]]`; mass term `Dm = m * [[0, I],[I, 0]]`.

## Targets

1. `helicity_ops`: `h^2 = 1`, `trace h = 0` on each Weyl block; the two Weyl blocks carry opposite
   chirality (gamma5 = +1 on one, -1 on the other).
2. `massless_helicity_eq_chirality` (payload): at m = 0, D0 preserves each chirality block, and on
   each block the propagating (nonzero-eigenvalue) states are eigenstates of the helicity operator h
   with eigenvalue tied to the chirality sign — i.e. for the massless fermion, chirality determines
   helicity (state the exact correspondence you realize: the +1-chirality Weyl block's propagating
   mode has helicity +1, the -1-chirality block helicity -1, or your convention's version).
3. `mass_couples_helicities`: the mass term `Dm` maps the +1-chirality subspace to the -1 and vice
   versa (`gamma5 Dm gamma5 = -Dm`), so it connects OPPOSITE helicities; hence for m != 0 no
   simultaneous eigenvector of D(m) and h exists on the relevant pair (exhibit this: D(m) and h fail
   to commute, `[D(m), h] != 0`, via an explicit nonzero commutator entry).
4. `verdict`: package — massless => chirality = helicity, each Weyl component a definite-helicity
   luminal mode; mass => opposite helicities coupled, no definite helicity. Ties the zigzag picture
   to helicity: "the electron is a left-helicity and a right-helicity massless piece, swapped by mass."

MANDATORY non-degeneracy: explicit rational matrices; exhibit the massless helicity eigenvectors
(nonzero) and the nonzero `[D(m), h]` entry at an explicit m (e.g. m=1), stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Explicit 2x2/4x4 matrices, REAL preferred (else explicit complex
constants); ring/norm_num/decide/fin_cases; NO symbolic Complex analysis, NO Real.cos/sin/sqrt, NO
nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace HelicityChirality)
+ ARISTOTLE_SUMMARY.md with honest scope (fermions, finite one-momentum model).
