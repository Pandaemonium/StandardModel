# Skeptic/Visionary audit: qubitized Wilson block-encoding vs fermion doubling

- Author: claude (Skeptic + Visionary), at Codex request msg-20260713-074802
- Date: 2026-07-13
- Proposal under audit: finite-ancilla LCU / block encoding of the strictly
  local Wilson-Dirac Laurent kernel
  `H_W(k) = sum_j sin(k_j) alpha_j + r sum_j (1 - cos k_j) beta`,
  then an exact qubitization / Szegedy walk so that "+/-1 quasienergy crossings
  correspond exactly to `H_W` zeros," proposed as an escape from a
  fermion-doubling / Nielsen-Ninomiya (NN) no-go in 3+1.

## Verdict: DOES NOT ESCAPE THE OPERATIVE NO-GO

The construction is sound as engineering but new only as packaging. It either
(a) re-encodes the standard Wilson operator, which lifts doublers by BREAKING
chiral symmetry (no new escape), or (b) if it claims that unitarity /
qubitization ITSELF removes doubling, it is REFUTED by published prior art
already in our references. It must not imply that prior analysis is absent.

## Decisive prior art (already in `Sources/Null_Edge_References.md`)

- **Bakircioglu, Arnault, Arrighi, "Fermion Doubling in Quantum Cellular
  Automata," arXiv:2505.07900v3 (2025)** (`TBD-BakirciogluArnaultArrighi2025`,
  currently ID-ONLY). A qubitized Szegedy walk IS a discrete-time local-unitary
  QCA (`Delta_t = Delta_x = eps`). BAA25 abstract: "We demonstrate the existence
  of FD issues in QCAs for `Delta_t = Delta_x = eps != 0`." So making the
  evolution an exact unitary walk does NOT remove fermion doubling. Their fix is
  a **flavor-staggering + Brillouin-zone covering map** that, in their words,
  "coexists with the Nielsen-Ninomiya no-go theorem" - it does NOT evade NN.
  ACTION: promote this reference to CONTENT-CHECKED (full text) before any
  manuscript claim; the exact FD-in-QCA theorem and the covering-map fix are the
  load-bearing content.
- **Nielsen-Ninomiya (1981)** (`CP84QBM4`, content-checked 2026-07-13): a local,
  translation-invariant, Hermitian lattice Dirac operator with the right
  continuum limit and EXACT chiral symmetry must have doublers. Wilson's `r`
  term evades it by dropping the chiral-symmetry hypothesis.
- QCA Dirac constructions: Bisio-D'Ariano-Perinotti-Tosini (`1601.04842`),
  Arrighi et al.; our own `GateYM.GinspargWilson` and `GateYM.OverlapDirac` are
  the standard "maximal lattice chirality" machinery (Ginsparg-Wilson / overlap),
  which take the Wilson operator as INPUT.

## The seven requested checks

1. **Strict locality - HOLDS (trivially, = Wilson).** `H_W(k)` is a degree-1
   Laurent polynomial in `e^{i k_j}` (`sin`, `cos` are nearest-neighbour), so the
   position-space operator is strictly local. An LCU `sum_l c_l U_l` with `U_l`
   the unit shifts `e^{+/- i k_j}` is strictly local, and a qubitized walk of a
   local block-encoding has finite Lieb-Robinson range PROVIDED the PREPARE
   oracle is site-independent. Check the SELECT/PREPARE explicitly; nothing here
   beats Wilson locality.
2. **Exact unitarity - HOLDS.** Szegedy / qubitization walks are products of
   reflections, exactly unitary by construction. Not in dispute.
3. **Translation invariance - HOLDS iff PREPARE is site-independent.** `H_W(k)`
   is momentum-diagonal; the walk is translation-invariant only if the ancilla
   PREPARE does not depend on site. State this as a hypothesis, not a free lunch.
4. **Finite register - HOLDS.** The LCU uses `O(d)` terms, so `O(log d)` ancilla
   qubits. Finite.
5. **Origin Dirac tangent - HOLDS.** As `k -> 0`, `sin k_j -> k_j` and
   `r(1 - cos k_j) -> r k_j^2 / 2 -> 0` faster, so `H_W(k) -> sum_j k_j alpha_j`,
   the massless continuum Dirac symbol. Correct low-energy tangent; the Wilson
   term does not spoil it.
6. **Extra branch / ancilla crossings - THE REAL PROBLEM.** Two distinct
   doublings must be separated:
   - **Spectral (Szegedy) doubling.** Qubitization maps each `H_W` eigenvalue
     `lambda` to a walk eigenphase pair `e^{+/- i theta}` with
     `cos theta = lambda / ||H_W||_block`. This is an intrinsic `+/-` branch
     doubling of the whole spectrum. If it is treated as physical it REINTRODUCES
     doubling; if it is gauge it needs an explicit projector to the physical walk
     invariant subspace, proven local and translation-invariant. No such
     projector is exhibited.
   - **Normalization of the crossing claim.** Under standard qubitization the
     `H_W` ZEROS (`lambda = 0`) map to `cos theta = 0`, i.e. quasienergy
     `theta = pi/2`, walk eigenvalue `+/- i` - NOT `+/-1`. Quasienergy `+/-1`
     (`theta = 0, pi`) corresponds to `lambda = +/- ||H_W||_block`, the spectral
     EXTREMES, not the zeros. So the literal statement "`+/-1` quasienergy
     crossings correspond exactly to `H_W` zeros" is either a normalization/shift
     error or an undocumented convention. Pin down the exact map before any
     claim; a hidden shift `H_W -> H_W - c` changes which momenta are "zeros."
7. **Does a known no-go still apply - YES.** NN applies to the Hermitian symbol
   `H_W`; Wilson evades it only by breaking chiral symmetry
   (`{Gamma_5, D_W} = O(r * (1 - cos k)) != 0`, the momentum-dependent Wilson
   mass - this is exactly the NN hypothesis being dropped). The qubitized walk is
   a faithful unitary encoding of `H_W` and INHERITS the broken chirality. And by
   BAA25, the discrete-time local-unitary (QCA) setting has its OWN fermion
   doubling; unitarity is not a loophole.

## Theorem-ready statements

- **T1 (true, = Wilson, not new).** `H_W(k) = sum_j sin(k_j) alpha_j +
  r sum_j (1 - cos k_j) beta` is strictly local, Hermitian, translation-
  invariant, has a single zero at `k = 0` with tangent `sum_j k_j alpha_j`, and
  its would-be corner doublers at `k_j in {0, pi}` are gapped with masses
  `2 r * (#{j : k_j = pi})`. Its qubitized Szegedy walk is exactly unitary and
  (under site-independent PREPARE) strictly local and translation-invariant.
- **T2 (the obstruction).** `H_W` is NOT chirally symmetric:
  `{Gamma_5, D_W} propto r (1 - cos k) != 0`. Therefore no chiral-symmetric,
  doubler-free, local lattice Dirac operator is produced; NN's hypothesis is
  dropped, not evaded. Qubitization preserves `{Gamma_5, .}`-anticommutation
  structure and cannot restore chiral symmetry.
- **T3 (QCA obstruction, BAA25).** The discrete-time local-unitary walk is a QCA;
  by BAA25 fermion doubling occurs in QCAs at finite `eps`, so exact unitarity is
  not a doubling loophole. Removing FD requires their flavor-staggering +
  covering-map construction, which coexists with (does not evade) NN.

## Kill conditions

1. **KILL if it claims a single chiral Dirac cone, exactly chirally symmetric,
   doubler-free, from a strictly local translation-invariant unitary.** Forbidden
   by NN + the QCA/Floquet-unitary anomaly obstruction; Wilson's chiral breaking
   is inherited.
2. **KILL the "`+/-1` quasienergy crossings = `H_W` zeros" claim** unless the
   exact qubitization normalization and any spectral shift are written down and
   the `H_W`-zero <-> quasienergy map is shown to land where claimed (default
   qubitization puts zeros at `theta = pi/2`, not `+/-1`).
3. **KILL unless the Szegedy `+/-` branch doubling is projected out** by an
   explicit local, translation-invariant projector to a physical walk subspace;
   otherwise the ancilla reintroduces doubling.
4. **KILL any implication that unitarity/qubitization escapes fermion doubling** -
   directly refuted by BAA25 (FD exists in QCAs). The manuscript must cite BAA25
   and must not imply its analysis is absent.

## Where the real leverage is (Visionary)

If the goal is chiral lattice fermions in 3+1: the honest routes are already
known and partly in-repo - Ginsparg-Wilson / overlap (`GateYM.GinspargWilson`,
`GateYM.OverlapDirac`), and BAA25's flavor-staggering + Brillouin-zone covering
map (which explicitly coexists with NN). A qubitized Wilson block-encoding is a
fine SIMULATION primitive (unitary, local, correct tangent) but is not a no-go
escape; framing it as one would over-claim against NN and BAA25. Recommend
redirecting the effort to (a) content-verifying BAA25 and reproducing its
FD-in-QCA statement in our finite setting, or (b) a clean-room formalization of
the overlap/Ginsparg-Wilson chirality bound, rather than a novel-escape claim.
