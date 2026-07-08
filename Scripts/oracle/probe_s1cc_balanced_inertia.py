"""S1-CC kill probe K-B: does the closure form have BALANCED inertia on V'/N?

Pre-registered by Fable call-01 Part B (kill condition K-B): on the 6x6
witness the restricted closure Krein form is predicted to have inertia
sig(J Q_C |_{V'/N}) = (rank K-bar, rank K-bar) = (2, 2). An UNBALANCED
non-vacuous result kills the S1-CC resolution's instantiation (the abstract
Theorems 1-3 survive; their concrete realization would not).

Witness (Fable B.3): Clifford factor C^2, color factor W = C^3.
  G = diag(0, 0, 1)         Hermitian Gauss operator, rank 1
  K = E01 - E10 (3x3)       skew-Hermitian curvature, [G,K] = 0
  J = sigma_x (x) I3        Krein fundamental symmetry
  b = sigma_z (x) I3        closure bivector grading
  Q_G = sqrt2 * E01 (x) G   nilpotent Gauss charge (single null covector)
  Q_C = b (x) K             closure slot (proportionality irrelevant to signs)

V' = ker Q_G;  N = radical of the J-form on V' (= range Q_G);
closure form on V'/N = (J Q_C) restricted to a J-nondegenerate complement
of N in V'. Report its inertia and check [G,K]=0, the anticonjugation
b^-1 (J Q_C) b = -(J Q_C), and dims.

Numeric oracle only; NOT a Lean result.
Usage: python Scripts/oracle/probe_s1cc_balanced_inertia.py
"""

import numpy as np

sx = np.array([[0, 1], [1, 0]], dtype=complex)
sz = np.array([[1, 0], [0, -1]], dtype=complex)
I3 = np.eye(3, dtype=complex)
E01_2 = np.array([[0, 1], [0, 0]], dtype=complex)  # 2x2 raising

# color-space data
G = np.diag([0.0, 0.0, 1.0]).astype(complex)         # Gauss operator
K = np.zeros((3, 3), dtype=complex)                  # curvature (skew)
K[0, 1] = 1.0
K[1, 0] = -1.0

J = np.kron(sx, I3)                                  # 6x6 fundamental symmetry
b = np.kron(sz, I3)                                   # 6x6 grading (anticonj)
QG = np.sqrt(2.0) * np.kron(E01_2, G)                 # nilpotent Gauss charge
QC = np.kron(sz, K)                                   # closure slot sigma_z (x) K


def inertia(H, tol=1e-9):
    ev = np.linalg.eigvalsh((H + H.conj().T) / 2.0)
    return (int(np.sum(ev > tol)), int(np.sum(ev < -tol)),
            int(np.sum(np.abs(ev) <= tol)))


def kernel_basis(M, tol=1e-9):
    """Orthonormal basis of ker M (columns)."""
    u, s, vh = np.linalg.svd(M)
    ns = vh.conj().T[:, [i for i in range(vh.shape[0])
                         if i >= len(s) or s[i] <= tol]]
    return ns


print("=== structural checks ===")
print(f"  [G,K] = 0 ? {np.allclose(G @ K - K @ G, 0)}")
print(f"  K skew-Hermitian ? {np.allclose(K.conj().T, -K)}")
print(f"  Q_G nilpotent (Q_G^2=0) ? {np.allclose(QG @ QG, 0)}")
print(f"  J Q_C Hermitian ? {np.allclose((J @ QC).conj().T, J @ QC)}")
# anticonjugation: b^-1 (J Q_C) b = -(J Q_C)
JQC = J @ QC
anti = np.linalg.inv(b) @ JQC @ b
print(f"  b^-1 (J Q_C) b = -(J Q_C) ? {np.allclose(anti, -JQC)}")

# V' = ker Q_G
Vp = kernel_basis(QG)
print(f"\n=== dimensions ===")
print(f"  dim V' = ker Q_G = {Vp.shape[1]} (predicted 5)")

# induced J-form on V'
JVp = Vp.conj().T @ J @ Vp
rad_dim = inertia(JVp)[2]
print(f"  J-form on V' inertia = {inertia(JVp)}; radical dim = {rad_dim} "
      f"(predicted N: 1)")

# complement of the radical N in V': span of non-null eigenvectors of JVp
evJ, UJ = np.linalg.eigh((JVp + JVp.conj().T) / 2.0)
keep = [i for i in range(len(evJ)) if abs(evJ[i]) > 1e-9]
comp = UJ[:, keep]                       # coords in V'-basis
Wp = Vp @ comp                           # ambient 6-dim vectors, J-nondegen
print(f"  dim (V'/N complement) = {Wp.shape[1]} (predicted 4)")

# closure form on the quotient complement
QC_form = Wp.conj().T @ (J @ QC) @ Wp
sig = inertia(QC_form)
print(f"\n=== THE KILL PROBE ===")
print(f"  sig(J Q_C |_{{V'/N}}) = {sig}")
pred = (np.linalg.matrix_rank(K[np.ix_([0, 1], [0, 1])]),) if False else None
# rank K-bar: K restricted to ker G. ker G = span(e0,e1); K|_{ker G} =
# 2x2 antisym block, rank 2.
kerG = kernel_basis(G)
Kbar = kerG.conj().T @ K @ kerG
rank_Kbar = np.linalg.matrix_rank(Kbar, tol=1e-9)
print(f"  rank K-bar (K on ker G) = {rank_Kbar}; predicted sig = "
      f"({rank_Kbar}, {rank_Kbar}, {Wp.shape[1] - 2*rank_Kbar})")
balanced = sig[0] == sig[1]
print(f"\n  VERDICT: {'BALANCED (resolution CONFIRMED)' if balanced else 'UNBALANCED - resolution instantiation KILLED'}"
      f"; matches predicted (2,2)? {sig[0] == rank_Kbar and sig[1] == rank_Kbar}")
