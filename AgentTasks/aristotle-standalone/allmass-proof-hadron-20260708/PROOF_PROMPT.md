# Proof/strategy: a finite interacting two-body bound state below threshold

PROOF + DESIGN job (a landed kernel lemma is the goal; a rigorous plan if it
resists). Context: `src/FockMassGap.lean` (the landed finite second-quantized
free mass gap; reproduce/extend it or import its ideas).

## Situation (finite mathematical-physics program: mass = obstruction to null transport)

The free second-quantized mass gap is DONE (`FockMassGap.secondQuantized_massGap`):
on the fermionic occupation Fock space over a one-particle sector with spectrum
`d : Fin N -> R`, the free many-body Hamiltonian `dGamma(B)` has ground energy 0,
first excited `= lam - kappa` (the one-particle gap), and the free two-body energy
is EXACTLY `d i + d j` (sum of constituents) - so NO bound state below threshold
for the FREE dynamics. The binding defect `Delta = -kappa` (block level, kernel
-proved in `BindingDefect`) is the seed: adding it drops the two-body energy below
`d i + d j` when `kappa > 0`. That is currently a hand-inserted seed, NOT a bound
state of an interacting operator.

## Target - earn the interacting bound state

1. **Build the interacting two-body form.** On the two-particle sector
   `Lambda^2(sector)` (occupation states with exactly 2 set bits, `Fin N choose 2`
   dimensional), define `H2 = dGamma(B)|_{Lambda^2} + V`, with a concrete finite
   interaction `V` seeded by the binding defect (e.g. an attractive rank-one/local
   `V` of strength `kappa` on the two lowest modes, chosen so `V` is Hermitian and
   its scale is exactly the closure strength). State the exact finite Lean types
   (a `Matrix (Sym2-of-modes) ... C` or an explicit small matrix for `N` small,
   e.g. `N = 3` giving a `3x3` two-particle space).
2. **The theorem (the real content).** Prove the least eigenvalue of `H2` lies
   **strictly below the free threshold** `min_{i != j} (d i + d j)` exactly when
   `kappa > 0` - a genuine finite bound state below the sum of constituents. For a
   small explicit `N` (e.g. N=3 or 4) this is a concrete Hermitian eigenvalue
   computation (`Matrix.PosDef`/`IsLeast`/charpoly). Deliver it as Lean if feasible;
   else give the exact obstruction and a ranked plan (the strategy note flagged the
   blocker: a min-max/variational estimate not packaged in Mathlib - so a direct
   small-matrix computation may be the cleanest route).
3. **Semantic honesty.** Be explicit about what makes this a "hadron mass" vs a
   toy: is `V` derived from the carrier's closure geometry, or inserted? State the
   grade (M for the matrix fact; the physical hadron identification is C).

Output: the interacting `H2` definition; the below-threshold bound-state theorem
(Lean if feasible, else plan + obstruction); the honest hadron-vs-toy boundary.
A correct small-N kernel result (bound state below threshold) beats an essay.
Run lake env lean; report semantic alignment; commit + push.
