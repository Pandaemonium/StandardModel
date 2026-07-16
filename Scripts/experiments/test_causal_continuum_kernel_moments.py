import numpy as np

from causal_continuum_kernel_moments import (
    _retarded_time_segments,
    binomial_averaged_smeared_kernel,
    binomial_averaged_smeared_kernel_second_moment,
    CutoffProfile,
    continuum_operator_moments,
    direct_binomial_smeared_kernel_moments,
    direct_poisson_smeared_kernel_mean,
    direct_poisson_smeared_kernel_second_moment,
    live_project_coefficient_error,
    poisson_averaged_smeared_kernel,
    poisson_averaged_smeared_kernel_second_moment,
    poisson_smeared_kernel_variance,
    quadrature_agreement,
    smooth_depth_cutoff,
)
from causal_operator_metric import (
    project_convention_row,
    smeared_bd_row,
    smeared_kernel,
)


def test_closed_poisson_transform_matches_direct_sum() -> None:
    for mean, epsilon, cutoff in (
        (0.0, 0.2, 20),
        (2.5, 0.1, 50),
        (12.0, 0.04, 90),
    ):
        direct = direct_poisson_smeared_kernel_mean(mean, epsilon, cutoff)
        closed = poisson_averaged_smeared_kernel(mean, epsilon)
        assert np.isclose(direct, closed, rtol=2.0e-12, atol=2.0e-12)


def test_closed_poisson_second_moment_matches_direct_sum() -> None:
    for mean, epsilon, cutoff in (
        (0.0, 0.2, 20),
        (2.5, 0.1, 60),
        (12.0, 0.04, 100),
    ):
        direct = direct_poisson_smeared_kernel_second_moment(
            mean, epsilon, cutoff
        )
        closed = poisson_averaged_smeared_kernel_second_moment(mean, epsilon)
        assert np.isclose(direct, closed, rtol=2.0e-11, atol=2.0e-11)


def test_closed_poisson_kernel_variance_is_nonnegative() -> None:
    for mean, epsilon in ((0.0, 0.2), (2.5, 0.1), (12.0, 0.04)):
        first = poisson_averaged_smeared_kernel(mean, epsilon)
        second = poisson_averaged_smeared_kernel_second_moment(mean, epsilon)
        assert np.isclose(
            poisson_smeared_kernel_variance(mean, epsilon),
            second - first**2,
            rtol=2.0e-12,
            atol=2.0e-12,
        )
        assert second + 1.0e-12 >= first**2


def test_closed_binomial_moments_match_direct_sum() -> None:
    for trials, probability, epsilon in (
        (0, 0.0, 0.2),
        (5, 0.3, 0.1),
        (20, 0.15, 0.04),
    ):
        direct_first, direct_second = direct_binomial_smeared_kernel_moments(
            trials, probability, epsilon
        )
        assert np.isclose(
            binomial_averaged_smeared_kernel(
                trials, probability, epsilon
            ),
            direct_first,
            rtol=2.0e-12,
            atol=2.0e-12,
        )
        assert np.isclose(
            binomial_averaged_smeared_kernel_second_moment(
                trials, probability, epsilon
            ),
            direct_second,
            rtol=2.0e-11,
            atol=2.0e-11,
        )


def test_binomial_kernel_moments_approach_poisson_at_fixed_mean() -> None:
    mean = 2.5
    epsilon = 0.1
    trials = 100_000
    probability = mean / trials
    assert np.isclose(
        binomial_averaged_smeared_kernel(trials, probability, epsilon),
        poisson_averaged_smeared_kernel(mean, epsilon),
        rtol=2.0e-4,
        atol=2.0e-6,
    )
    assert np.isclose(
        binomial_averaged_smeared_kernel_second_moment(
            trials, probability, epsilon
        ),
        poisson_averaged_smeared_kernel_second_moment(mean, epsilon),
        rtol=2.0e-4,
        atol=2.0e-6,
    )


def test_smooth_cutoff_has_frozen_zero_and_one_regions() -> None:
    profile = CutoffProfile("test", 0.02, 0.08)
    depth = np.array([0.0, 0.02, 0.05, 0.08, 1.0])
    values = smooth_depth_cutoff(depth, profile)
    assert np.array_equal(values[[0, 1]], np.zeros(2))
    assert np.array_equal(values[[3, 4]], np.ones(2))
    assert 0.0 < values[2] < 1.0


def test_retarded_time_segments_include_exact_cutoff_intersections() -> None:
    profile = CutoffProfile("test", 0.02, 0.08)
    segments = _retarded_time_segments(1.0, profile)
    boundaries = [segments[0][0], *(segment[1] for segment in segments)]
    for depth in (profile.depth_zero, profile.depth_one):
        assert any(
            np.isclose(value, 0.5 * (1.0 - np.sqrt(depth)))
            for value in boundaries
        )
        assert any(
            np.isclose(value, 1.0 - depth**0.25)
            for value in boundaries
        )


def test_registered_angular_zero_classes_are_not_numerically_fitted() -> None:
    result = continuum_operator_moments(
        0.25,
        CutoffProfile("test", 0.02, 0.08),
        quadrature_order=24,
    )
    assert set(result.operator_values) == {
        "constant",
        "temporal_affine",
        "temporal_quadratic",
        "spatial_quadratic",
        "temporal_cubic",
        "temporal_spatial_cubic",
    }
    assert len(result.metric_diagonal) == 4
    assert result.metric_diagonal[1:] == [result.metric_diagonal[1]] * 3


def test_quadrature_agreement_detects_identical_settings() -> None:
    profile = CutoffProfile("test", 0.02, 0.08)
    result = continuum_operator_moments(0.25, profile, quadrature_order=20)
    agreement = quadrature_agreement(result, result)
    assert agreement["passes"]
    assert all(item["absolute"] == 0.0 for item in agreement["fields"].values())


def test_continuum_sign_and_coefficients_match_live_project_row() -> None:
    ell = 0.1
    nonlocality_scale = 0.2
    epsilon = (ell / nonlocality_scale) ** 4
    past = np.array([True, True, False])
    counts = np.array([0, 3, 0])
    actual = project_convention_row(
        smeared_bd_row(past, counts, 2, ell, nonlocality_scale)
    )
    prefactor = 4.0 / (np.sqrt(6.0) * nonlocality_scale**2)
    expected = np.zeros(3)
    expected[past] = (
        -prefactor * epsilon * smeared_kernel(counts[past], epsilon)
    )
    expected[2] = prefactor
    assert np.allclose(actual, expected, rtol=0.0, atol=1.0e-14)
    assert live_project_coefficient_error() == 0.0
