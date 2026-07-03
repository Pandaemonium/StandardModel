import PhysicsSM.Draft.NullEdge.GateC1.OverlapLocality

/-!
# Gate C1 overlap locality certificates

This module packages the locality results of `OverlapLocality` into small
certificate structures that later C1 files can depend on.

The purpose is architectural: downstream overlap/sign-kernel code should ask
for named locality certificates rather than repeating the full polynomial
approximation theorem every time.  The certificates here are still finite and
abstract; they do not by themselves construct the physical null-edge overlap
operator.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace OverlapLocalityCertificates

open scoped Matrix BigOperators
open OverlapLocality

variable {Site : Type*}

/-- A named certificate that a matrix has finite range. -/
structure FiniteRangeCertificate
    (D : SiteDist Site) (r : ℕ) (M : Matrix Site Site ℂ) : Prop where
  /-- Matrix entries vanish beyond range `r`. -/
  is_range : IsRange D r M

/-- A named certificate that a matrix is exponentially/quasi-locally decaying. -/
structure ExpLocalCertificate
    (D : SiteDist Site) (C q : ℝ) (M : Matrix Site Site ℂ) : Prop where
  /-- Positive envelope constant. -/
  C_pos : 0 < C
  /-- Nonnegative decay base. -/
  q_nonneg : 0 ≤ q
  /-- Strict decay base. -/
  q_lt_one : q < 1
  /-- Entrywise geometric decay in the site distance. -/
  exp_local : ExpLocal D C q M

/-- A finite-range certificate can be weakened to a larger range. -/
theorem FiniteRangeCertificate.mono
    (D : SiteDist Site) {r s : ℕ} {M : Matrix Site Site ℂ}
    (hrs : r ≤ s) (hM : FiniteRangeCertificate D r M) :
    FiniteRangeCertificate D s M :=
  ⟨isRange_mono D hrs hM.is_range⟩

/-- Polynomial overlap surrogate locality, packaged as a certificate. -/
theorem overlap_surrogate_finite_range_certificate
    [Fintype Site] [DecidableEq Site]
    (D : SiteDist Site) {r : ℕ} {gamma5 H : Matrix Site Site ℂ}
    (hg : IsRange D 0 gamma5) (hH : IsRange D r H)
    (p : Polynomial ℂ) {n : ℕ} (hdeg : p.natDegree ≤ n) :
    FiniteRangeCertificate D (n * r)
      (OverlapGinspargWilson.Dov gamma5 (Polynomial.aeval H p)) :=
  ⟨overlap_surrogate_finite_range D hg hH p hdeg⟩

/-- The main sign-kernel locality theorem, packaged as an exponential locality
certificate. -/
theorem sign_kernel_expLocal_certificate
    [Fintype Site] [DecidableEq Site]
    (D : SiteDist Site) {r : ℕ} (hr : 1 ≤ r) {H eps : Matrix Site Site ℂ}
    (hH : IsRange D r H)
    {A kappa : ℝ} (hA : 0 ≤ A) (hkappa : 0 < kappa)
    (p : ℕ -> Polynomial ℂ)
    (hdeg : ∀ n, (p n).natDegree ≤ n)
    (happ : ∀ n i j,
      ‖(eps - Polynomial.aeval H (p n)) i j‖ ≤
        A * Real.exp (-kappa * n)) :
    ∃ C q : ℝ, ExpLocalCertificate D C q eps := by
  obtain ⟨C, q, hC, hq0, hq1, hlocal⟩ :=
    sign_kernel_exp_locality_target D hr hH hA hkappa p hdeg happ
  exact ⟨C, q, ⟨hC, hq0, hq1, hlocal⟩⟩

/-! ## Literature-facing certificate bundle -/

section AnalyticFrontier

variable [Fintype Site] [DecidableEq Site]

/-- Bounded-hopping certificate: the Hermitian seed kernel `H` has finite range
at least one. -/
structure BoundedHoppingCertificate
    (D : SiteDist Site) (H : Matrix Site Site ℂ) where
  /-- The hopping range. -/
  range : ℕ
  /-- The range is nonzero, matching the truncation theorem hypotheses. -/
  range_pos : 1 ≤ range
  /-- The kernel is finite-range at `range`. -/
  is_range : IsRange D range H

/-- Spectral-gap certificate: the spectrum of `H` avoids a neighborhood of
zero.  This is the hypothesis that should be supplied by the physical overlap
kernel audit. -/
structure SpectralGapCertificate (H : Matrix Site Site ℂ) where
  /-- The half-width of the gap around zero. -/
  gap : ℝ
  /-- The gap is positive. -/
  gap_pos : 0 < gap
  /-- Every spectral value has norm at least `gap`. -/
  spectrum_avoids : ∀ mu ∈ spectrum ℂ H, gap ≤ ‖mu‖

/-- Polynomial sign-approximation family with linearly growing degree and
exponentially decaying entrywise error. -/
structure SignApproxFamily (H eps : Matrix Site Site ℂ) where
  /-- The approximating polynomials. -/
  poly : ℕ -> Polynomial ℂ
  /-- Degree grows at most linearly. -/
  degree_bound : ∀ n, (poly n).natDegree ≤ n
  /-- Nonnegative approximation amplitude. -/
  amp : ℝ
  /-- Positive exponential rate. -/
  rate : ℝ
  /-- The amplitude is nonnegative. -/
  amp_nonneg : 0 ≤ amp
  /-- The rate is positive. -/
  rate_pos : 0 < rate
  /-- Entrywise exponential approximation bound. -/
  approx : ∀ n i j,
    ‖(eps - Polynomial.aeval H (poly n)) i j‖ ≤ amp * Real.exp (-rate * n)

/-- Abstract gauge-admissibility placeholder.  The concrete admissibility
condition should later be replaced by the chosen plaquette/smoothness bound. -/
structure GaugeAdmissibility (H : Matrix Site Site ℂ) where
  /-- The abstract admissibility proposition. -/
  admissible : Prop
  /-- Proof that the abstract admissibility proposition holds. -/
  holds : admissible

/-- Bundled certificate consumed by the verified finite locality theorem. -/
structure OverlapLocalityCertificate
    (D : SiteDist Site) (H eps : Matrix Site Site ℂ) where
  /-- Finite-range bounded-hopping input. -/
  hopping : BoundedHoppingCertificate D H
  /-- Polynomial sign-approximation input. -/
  approx : SignApproxFamily H eps

/-- A bundled locality certificate yields exponential locality of the sign
kernel. -/
theorem OverlapLocalityCertificate.expLocal
    {D : SiteDist Site} {H eps : Matrix Site Site ℂ}
    (cert : OverlapLocalityCertificate D H eps) :
    ∃ C q : ℝ, ExpLocalCertificate D C q eps := by
  exact sign_kernel_expLocal_certificate D cert.hopping.range_pos
    cert.hopping.is_range cert.approx.amp_nonneg cert.approx.rate_pos
    cert.approx.poly cert.approx.degree_bound cert.approx.approx

/-- Literature input: a spectral gap should produce an exponentially good
polynomial sign-approximation family.  This is the Hernandez-Jansen-Luscher
style analytic theorem to cite or formalize later, not a theorem proved here. -/
def AnalyticSignApproxHypothesis (H eps : Matrix Site Site ℂ) : Type :=
  SpectralGapCertificate H -> SignApproxFamily H eps

/-- Conditional locality from bounded hopping, a spectral gap, and the external
analytic sign-approximation theorem. -/
theorem expLocal_of_gap_and_analytic
    {D : SiteDist Site} {H eps : Matrix Site Site ℂ}
    (hopping : BoundedHoppingCertificate D H)
    (gap : SpectralGapCertificate H)
    (analytic : AnalyticSignApproxHypothesis H eps) :
    ∃ C q : ℝ, ExpLocalCertificate D C q eps :=
  (OverlapLocalityCertificate.mk hopping (analytic gap)).expLocal

end AnalyticFrontier

end OverlapLocalityCertificates
end GateC1
end NullEdge
end Draft
end PhysicsSM
