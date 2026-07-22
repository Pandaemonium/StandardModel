# Summary of changes for run 822a97dc-b1a0-46a0-8248-a72288398b6a
Implemented and verified the compact-group frame-blindness formalization in `RequestProject/Main.lean`.

Proved:
- variance is constant along orbits of a continuous orthogonal compact-group representation;
- for PSD operators, zero quadratic variance implies the vector lies in the kernel;
- equivariant kernels are group-invariant;
- suppression propagates to the whole orbit and its real linear span;
- the continuous compact-group obstruction: a moved vector cannot be suppressed alone by an invariant PSD operator;
- the finite-group averaging bridge: the normalized conjugation average is invariant and PSD, and its variance is the normalized orbit average;
- zero averaged variance forces zero variance at every orbit sample, formalizing that averaging delocalizes suppression;
- a general rank-one sharpness construction;
- a concrete compact continuous example using the circle acting by rotations on `ℂ ≅ ℝ²`, with invariant zero covariance and a non-invariant rank-one covariance selectively suppressing the imaginary line.

The Haar bridge is explicitly treated via the permitted finite-group alternative; the main obstruction itself is stated and proved for continuous compact groups.

Verification:
- the project builds successfully;
- no `sorry`, `axiom`, `native_decide`, or unfinished proof queries remain;
- reported theorem axioms are only `propext`, `Classical.choice`, and `Quot.sound`.
