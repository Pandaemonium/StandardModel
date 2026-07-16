import numpy as np

from causal_retarded_moment_debiased_metric import (
    retarded_time_response_correction_with_jet,
)


def test_response_first_jet_is_affine_probe_covariant() -> None:
    metric = np.diag([2.0, -0.8, -0.9, -1.1])
    metric_jet = np.zeros((4, 4, 4))
    metric_jet[0] = np.diag([0.2, -0.1, -0.05, -0.08])
    moment = np.array([-0.3, 0.02, -0.01, 0.01])
    moment_jet = np.zeros((4, 4))
    moment_jet[0] = np.array([-0.04, 0.01, 0.0, -0.005])
    linear = np.array(
        [
            [1.1, 0.1, 0.0, 0.0],
            [0.2, 0.9, 0.1, 0.0],
            [0.0, 0.1, 1.2, 0.1],
            [0.0, 0.0, 0.1, 0.8],
        ]
    )
    corrected, corrected_jet, norm = (
        retarded_time_response_correction_with_jet(
            metric, metric_jet, moment, moment_jet, 0.6
        )
    )
    transformed_metric_jet = np.array(
        [linear @ derivative @ linear.T for derivative in metric_jet]
    )
    transformed_moment_jet = np.array(
        [linear @ derivative for derivative in moment_jet]
    )
    transformed, transformed_jet, transformed_norm = (
        retarded_time_response_correction_with_jet(
            linear @ metric @ linear.T,
            transformed_metric_jet,
            linear @ moment,
            transformed_moment_jet,
            0.6,
        )
    )
    np.testing.assert_allclose(transformed, linear @ corrected @ linear.T)
    np.testing.assert_allclose(
        transformed_jet,
        np.array([linear @ derivative @ linear.T for derivative in corrected_jet]),
    )
    np.testing.assert_allclose(transformed_norm, norm)
