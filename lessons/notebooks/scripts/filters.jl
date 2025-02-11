import ForneyLab: ProbabilityDistribution, Univariate, GaussianMeanVariance
import Plots: plot, plot!, xlabel!, ylabel!


function plot_messages(state_prediction::ProbabilityDistribution{Univariate, GaussianMeanVariance},
                       measurement_likelihood::ProbabilityDistribution{Univariate, GaussianMeanVariance},
                       corrected_state_prediction::ProbabilityDistribution{Univariate, GaussianMeanVariance})

    # Extract parameters
    m_p = mean(state_prediction)
    v_p = var(state_prediction)
    m_l = mean(measurement_likelihood)
    v_l = var(measurement_likelihood)
    m_c = mean(corrected_state_prediction)
    v_c = var(corrected_state_prediction)

    # Set plot range
    range_p = [m_p - 8*sqrt(v_p), m_p + 8*sqrt(v_p)]
    range_l = [m_l - 8*sqrt(v_l), m_l + 8*sqrt(v_l)]
    range_c = [m_c - 8*sqrt(v_c), m_c + 8*sqrt(v_c)]
    plot_range = range(minimum([range_p[1], range_l[1], range_c[1]]),
                       maximum([range_p[2], range_l[2], range_c[2]]), length=300)

    # Probabilities over range
    probs_p = [pdf(state_prediction, a) for a in plot_range]
    probs_l = [pdf(measurement_likelihood, a) for a in plot_range]
    probs_c = [pdf(corrected_state_prediction, a) for a in plot_range]

    # Start plotting
    plot(plot_range, probs_p, color="red", label="state prediction", size=(800,500))
    plot!(plot_range, probs_l, color="blue", label="observation likelihood")
    plot!(plot_range, probs_c, color="green", label="state estimate")
    xlabel!("x-coordinate")
    ylabel!("Probability")
end

function pdf(dist::ProbabilityDistribution{Univariate, GaussianMeanVariance}, x::Number)
    return exp(-0.5*(log(2*pi) + log(dist.params[:v]) + (x - dist.params[:m])^2 / dist.params[:v]))
end;