# Literature pass: interacting QCA sector stability and controlled leakage

Date: 2026-07-21
Role: Archivist / Research Scientist
Work item: `QCA-3PLUS1-001`

## Question

Must a proposed positive-energy or decoded HNU sector be exactly invariant
under every local interaction, or is a quantitative small-leakage theorem the
more physically appropriate gate?

## Primary-source findings

1. Bisio, D'Ariano, Perinotti, and Tosini construct the interacting Thirring
   QCA as a free Dirac automaton followed by an onsite number-preserving
   interaction and solve its two-particle sector. This is direct precedent for
   split free-plus-local-interaction evolution, but not for preservation of a
   selected positive-energy band.
   <https://arxiv.org/abs/1711.03920>

2. Bisio, Perinotti, Pizzamiglio, and Rota develop a perturbative path-sum
   expansion for the Thirring QCA, including two- and three-particle sectors.
   Their organization by interaction vertices supports treating sector leakage
   as a controlled dynamical quantity rather than assuming it away.
   <https://arxiv.org/abs/2406.19917>

3. Brun and Mlodinow identify a direct tension among symmetry, strict locality,
   and positive-energy restriction in interacting fermion/boson QCA. Their
   onsite interaction necessarily couples to unwanted negative-energy bosonic
   modes in the analyzed model. Extending the interaction over a larger but
   finite range makes the unwanted production exponentially small in that
   range, according to their analytic/numerical construction. This is the
   decisive source for relaxing exact HNU sector invariance to an explicit
   leakage bound with a range/depth schedule.
   <https://arxiv.org/abs/2503.05998>

4. Piroli, Turzillo, Shukla, and Cirac classify one-dimensional fermionic
   locality-preserving unitaries through generalized matrix-product unitaries.
   They emphasize that fermionic locality and strict causal-cone formulations
   require graded care. This supports stating locality through CAR-algebra
   transport, as in the landed finite modules, rather than only basis support.
   <https://arxiv.org/abs/2007.11905>

## Consequence for the HNU program

Keep two distinct gates.

### Exact gate

For a declared orthogonal sector projector `P`, classify interaction
Hamiltonians by

```text
[H,P] = 0  iff  every selected/complement cross block of H vanishes.
```

This is the clean structural criterion. Aristotle project
`4dfca880-8f38-4917-9ebb-2c3cc93358f1` is proving it together with a nonzero
Pluecker pair-transfer control.

### Quantitative relaxed gate

For one-step contraction/unitary `U`, prove the elementary commutator telescope

```text
||U^n P - P U^n|| <= n ||U P - P U||.
```

For an orthogonal projector this bounds leakage from the selected sector by
the same right-hand side. If an interaction family of range `R` has one-step
commutator at most `C exp(-c R)`, a schedule with
`n C exp(-c R_n) -> 0` gives asymptotic sector decoupling without demanding
exact invariance at finite regulator.

This route is scientifically stronger than silently projecting after every
step: it makes the unwanted-sector amplitude an observable error budget and
states how locality range must scale with evolution depth.

## Kill conditions

- Exact preservation is unavailable if the intended interaction has a
  nonzero selected/complement block.
- Approximate preservation fails if the cross-sector commutator does not shrink
  fast enough to beat accumulated depth.
- A small endpoint leakage norm is not positive energy, anomaly cancellation,
  or an interacting continuum limit.
- A projector chosen after diagonalizing the full interacting update is not an
  independently derived physical decoder.

## Next formal target

Prove the commutator-power telescope and projector leakage bound in a generic
normed algebra, then instantiate it on a finite matrix interaction family. A
second theorem should package the exponential-in-range hypothesis into a
vanishing changing-depth schedule.
