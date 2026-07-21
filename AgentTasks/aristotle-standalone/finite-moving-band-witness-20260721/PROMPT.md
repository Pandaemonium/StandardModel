# Aristotle target: exact gapped moving-band witness

Run this first:

`lake env lean FiniteMovingBandWitness.lean`

Fill every proof placeholder without changing any theorem statement. You may
add small helper lemmas. The central deliverables are:

1. exact rank-one projector and two-level gap identities;
2. exact factorization of the moving-projector defect;
3. a nonzero local defect at every finite scheduled step;
4. the `4/N^2` local bound; and
5. the vanishing `N * 4/N^2` accumulated budget.

Do not replace the moving projector by a fixed projector or make the finite
defect zero. Do not add a simple-spectrum assumption: the displayed family
already supplies the explicit eigenbasis. If the matrix operator norm API is
convenient, an additional theorem identifying or bounding the operator norm of
the defect by `abs defectAmplitude` is welcome, but it is not required to keep
the stated theorem suite unchanged.

The physics reading is deliberately scoped. This is an exact finite witness
that a uniformly gapped band can move nontrivially while a changing-regulator
leakage budget vanishes. It does not instantiate HNU, prove an adiabatic
theorem, establish quasi-locality, or handle interactions.
