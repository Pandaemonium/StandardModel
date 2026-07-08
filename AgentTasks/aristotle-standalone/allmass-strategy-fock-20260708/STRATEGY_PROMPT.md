# Strategy: a finite second-quantized mass gap from the first-quantized carrier

STRATEGY + DESIGN job (a landed kernel lemma is a bonus). Context in `src/` (the
program's existing finite-Fock modules).

## Situation (finite mathematical-physics program: mass = obstruction to null transport)

Everything kernel-checked so far is FIRST-QUANTIZED: the carrier `D` is a
one-particle operator on a finite-dimensional space; "mass" is the least eigenvalue
of a compressed sector form `B(lam,kappa)` (squared mass gap = aperture - closure =
`lam - kappa`, kernel-proved). There is currently NO second-quantized mass gap: no
Fock-space many-body ground state, no genuine "hadron mass" as the gap above a
second-quantized vacuum. The `src/` files (`FockSecondQuantization`,
`FockGradedRadical`, `FockQuotientPairing`) build a finite Fock/Gupta-Bleuler
shadow but do not yet land a many-body mass gap.

## Your task

1. **Define the finite second-quantized mass gap precisely.** Given the
   one-particle sector Hamiltonian/mass form `B` (Hermitian, least eigenvalue
   `lam - kappa > 0` on the physical sector), construct the finite second-quantized
   object: the Fock space `⊕_k Λ^k(sector)` (fermionic) or `Sym`(bosonic), the
   many-body Hamiltonian `dΓ(B)` (second quantization of `B`), and the mass gap
   `= E_1 - E_0` (first excited minus ground). State the exact finite Lean types.
2. **The sharpest TRUE finite statement.** What is provable now? e.g.
   `dΓ(B)` ground energy `= 0` (empty state) and first excited `= lam - kappa`
   (one particle in the ground mode), so the **second-quantized gap = the
   one-particle gap `lam - kappa`** - a clean finite theorem if the fermionic Fock
   construction is available in Mathlib (or cheaply built). Deliver it as Lean if
   cheap; else give the proof plan + the Mathlib API (`ExteriorAlgebra`,
   `⨁`, second quantization).
3. **What is NOT earned.** A genuine *hadron* mass (bound state of the
   *interacting* many-body system, mass NOT equal to the sum of constituents)
   requires interactions in `dΓ` beyond the free `dΓ(B)`. Where is the line
   between "free second-quantized gap (provable)" and "interacting bound-state
   hadron mass (open/hard)"? Is the binding-defect `Delta = -kappa` (block level,
   already kernel-proved) the right seed for the interaction, and can a finite
   two-body bound state below threshold be constructed?
4. **Feasibility + ranked sub-lemmas + blocker.**

Output: the finite 2nd-quantized mass-gap definition; the sharpest true statement
(+ Lean if cheap, else plan); the free-vs-interacting boundary; feasibility + the
blocker. A correct small kernel lemma (free gap = one-particle gap) beats an essay.
