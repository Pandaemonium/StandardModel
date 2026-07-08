# Fable-5 call 05 (solo run): manuscript completeness + dynamics-layer review

You are the most capable mathematical-physics referee on this program. This is a
**solo autonomous run** whose two goals are (1) completely finish the manuscript
(as a self-contained Markdown draft, including complete/verified references) and
(2) flesh out the dynamics layer so the Lean code informs Python simulations.
The complete manuscript is provided verbatim below. Assess it against those two
goals and tell me what remains.

## Program state (standalone; assume no prior knowledge)

Finite, machine-verified mathematical-physics program: **mass is the obstruction
to coherent null transport**. Kernel-checked (Lean 4, axiom-audited,
guard-pinned) results now include: §3 the Plücker mass `det P = Σ|ψ_i∧ψ_j|²`
(classical spinor-helicity, formalized); §4 the four-channel Krein budget
`4 D^#D = Q_A+Q_C+4Q_T+4E_#`; the Rayleigh-Ritz keystone `sector_ground_mass`;
**`T2_positive_mass`** — an explicit two-edge Cl(4) carrier with a positive-
definite physical sector, so the keystone *fires* to give a genuine positive
squared mass (the former positivity crux, now resolved in the kernel); the
**free §3↔§4 bridge** `free_mass_operator_eq_plucker` (`P·adjugate P = det P·1`,
so the free operator mass IS the kinematic mass); mass monogamy (Plücker
superadditivity) + general-partition form; finite Witten/Lichnerowicz positivity
(F4); and the **entire dynamics stack D1-D5**: `FiniteCarrierAction` (action +
Euler-Lagrange EOM), `FiniteUnitaryEvolution` (norm+energy conserved under
`exp(-iHt)`), `FiniteRGFlow`, `FiniteCanonicalEnsemble`.

Grades: **T** source-verified, **M** kernel-checked, **MEMO** expert/LLM-oracle
prose, **C** pre-registered conjecture with a kill condition.

Dynamics simulations (numeric oracle, each validated against a landed M-identity):
a carrier **spectrum/phase** sim (result: physical-sector mass gap = aperture −
closure, massless critical line at closure = aperture) and a **time-evolution/
scattering** sim (unitary flow, mass-spectrum resolution, quantum-walk transfer
operator, 2-fermion Slater amplitudes).

Open, honestly: T3b (name the Δ binding-defect a finite invariant), a continuum
reduction for one channel (checkerboard), carrier rigidity, second quantization →
a genuine hadron mass, the neutrino ratio (needs a mass-value map we lack).

## Your exact task — two questions

1. **Is the manuscript complete and publication-ready as a Markdown draft, and
   if not, what is the shortest path to "done"?** Check: internal consistency
   (grades vs claims; no stale "next-target" wording now that T2/free-bridge
   landed); completeness (does anything essential — a definition, a caveat, a
   result — go unstated?); the references section (complete? correctly scoped?);
   the abstract/intro/§10/§11/appendix reflecting the *current* state; exposition
   (is the §4 worked example and Appendix A reproducibility enough?). Give a
   concrete, ordered "remaining to finish" list. Be a demanding referee.
2. **Is the dynamics layer sound, and what is the single highest-value next
   dynamics theorem or simulation** to make the Lean→Python simulation program
   strongest? (Candidates: the Δ binding-energy dynamics; a spectral/mass-gap
   theorem generalizing T2; a transfer-operator continuum-limit theorem tying to
   the checkerboard/QW literature; a scattering/S-matrix finite object; the
   thermodynamic-limit/condensate via the canonical ensemble.) Rank them.

## Required output

- **Verdict (3-5 sentences):** manuscript completeness + dynamics soundness.
- **Manuscript "remaining to finish" — ordered list**, each item concrete and
  small enough to close in one editing pass.
- **Correctness/consistency flags**, most severe first (any stale claim, grade
  slip, or gap). If none, say so and say what you checked.
- **Dynamics: the ranked next moves** (theorem or simulation), with the concrete
  first step for the top one.
- **Bottom line:** the 2-3 things that most stand between here and "manuscript
  finished + dynamics as strong as it can be this run."

Be specific and technical; one sharp correct load-bearing criticism beats ten
generic ones. Report even if the news is bad.
