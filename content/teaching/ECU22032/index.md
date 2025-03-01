---
title: Statistical Inference
summary: Sampling theory and point estimation
date: 2025-03-01
type: docs
math: true
tags:
  - Statistics
  - Data Analysis
  - Sampling Theory
image:
  caption: 'Statistical concepts for evidence-based decision-making'
---

## Chapter 2.1 - Sampling Theory

### 1. Introduction to Sampling

Let's first understand the key parameters we want to study in a population.

{{< spoiler text="👉 Population Parameters" >}}
{{< math >}}
$$\text{For a random variable X representing a characteristic in the population:}$$
$$\text{• The population mean } \mu \text{ is the expected value of X:}$$
$$\mu = E(X) = \int_{-\infty}^{\infty} xf(x)dx \text{ or } \sum_{x} xP(X = x)$$
$$\text{depending on whether X is continuous or discrete.}$$
$$\text{• The population variance } \sigma^2 \text{ measures the spread around } \mu \text{:}$$
$$\sigma^2 = E[(X - \mu)^2] = E(X^2) - [E(X)]^2$$
$$\text{• The population standard deviation } \sigma \text{ is the square root of the variance}$$
{{< /math >}}
{{< /spoiler >}}

Sampling is crucial in statistics because examining entire populations is often impractical or impossible. Whether determining average student heights, testing product quality, or predicting elections, we rely on samples to infer population characteristics.

{{< spoiler text="👉 Population vs Sample" >}}
{{< math >}}
$$\text{In statistics, we distinguish between:}$$
$$\text{• The population: The entire group we're interested in studying}$$
$$\text{• A sample: A subset of the population that we actually observe}$$
$$\text{• The sampling frame: The list of all possible units that could be selected}$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Random Sample" >}}
{{< math >}}
$$\text{A random sample of size n is a collection of observations } X_1, X_2, \ldots, X_n \text{ where:}$$
$$\text{• Each } X_i \text{ follows the same probability distribution (identically distributed)}$$
$$\text{• The value of any } X_i \text{ doesn't affect the others (independent)}$$
{{< /math >}}

We often write this as "i.i.d." (independent and identically distributed).
{{< /spoiler >}}

### 2. Common Sampling Methods

Beyond simple random sampling, several other methods are commonly used:

{{< spoiler text="👉 Stratified Sampling" >}}
- Population divided into subgroups (strata)
- Each stratum sampled independently
- Ensures representation of all subgroups
- Often more precise than simple random sampling
{{< /spoiler >}}

{{< spoiler text="👉 Cluster Sampling" >}}
- Population divided into clusters
- Entire clusters are randomly selected
- All units within selected clusters are sampled
- More cost-effective for geographically dispersed populations
{{< /spoiler >}}

{{< spoiler text="👉 Systematic Sampling" >}}
- Units selected at fixed intervals
- Choose random start, then select every kth unit
- Simple to implement
- Risk of bias if population has periodic patterns
{{< /spoiler >}}

### 3. Common Sampling Biases

Even with careful sampling design, several biases can affect our data collection:

{{< spoiler text="👉 Selection Bias" >}}
When certain groups are over/under-represented in the sample:
- Convenience sampling (e.g., only surveying people at a shopping mall)
- Volunteer bias (those who choose to participate may differ systematically)
{{< /spoiler >}}

{{< spoiler text="👉 Non-response Bias" >}}
When those who don't respond differ from those who do:
- People with strong opinions more likely to respond
- Certain demographics harder to reach
{{< /spoiler >}}

{{< spoiler text="👉 Social Desirability Bias" >}}
When respondents modify answers to appear more favorable:
- Underreporting socially undesirable behaviors
- Overreporting positive behaviors
{{< /spoiler >}}

{{< spoiler text="👉 Survivorship Bias" >}}
When only "survivors" are included in the sample:
- Studying only successful businesses
- Analyzing only products that reached the market
{{< /spoiler >}}

### 4. Sample Statistics

When we have a sample, we calculate summary values that tell us about the population.

{{< spoiler text="👉 Sample Mean" >}}
{{< math >}}
$$\text{For a sample } X_1, X_2, \ldots, X_n, \text{ the sample mean is:}$$
$$\bar{X} = \frac{1}{n}\sum_{i=1}^{n}X_i$$
$$\text{This estimates the population mean } \mu = E(X).$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Sample Variance" >}}
{{< math >}}
$$\text{The sample variance measures spread around the mean:}$$
$$S^2 = \frac{1}{n-1}\sum_{i=1}^{n}(X_i - \bar{X})^2$$
$$\text{This estimates the population variance } \sigma^2 = \text{Var}(X).$$
{{< /math >}}

There's an important distinction between population and sample variance:
1. Population variance: σ² = E[(X − μ)²] - Uses the true population mean μ
2. Sample variance: S² = (1/(n−1))∑(Xᵢ − X̄)² - Uses the sample mean X̄ as an estimate of μ

Why n − 1? When we estimate the mean from the sample, we lose one degree of freedom. The division by (n − 1) corrects for this and ensures E(S²) = σ².
{{< /spoiler >}}

{{< spoiler text="👉 Standard Deviation vs Standard Error" >}}
{{< math >}}
$$\text{For a sample } X_1, X_2, \ldots, X_n:$$
$$\text{• The sample standard deviation } S \text{ measures the spread of individual observations:}$$
$$S = \sqrt{\frac{1}{n-1}\sum_{i=1}^{n}(X_i - \bar{X})^2}$$
$$\text{• The standard error (SE) measures the precision of a sample statistic:}$$
$$SE(\bar{X}) = \frac{S}{\sqrt{n}}$$
{{< /math >}}

The standard deviation measures how much individual observations vary, while the standard error measures how precisely we estimate parameters like the mean.
{{< /spoiler >}}

### 5. Properties of Sample Statistics

Key properties of the sample mean:

{{< spoiler text="👉 Properties of Sample Mean" >}}
{{< math >}}
$$\text{Let } X_1, X_2, \ldots, X_n \text{ be a random sample with } E(X_i) = \mu \text{ and } \text{Var}(X_i) = \sigma^2. \text{ Then:}$$
$$\text{1. } E(\bar{X}) = \mu \text{ (unbiased)}$$
$$\text{2. } \text{Var}(\bar{X}) = \frac{\sigma^2}{n} \text{ (variance decreases with sample size)}$$
{{< /math >}}

The variance formula Var(X̄) = σ²/n shows that:
- Larger samples give more precise estimates
- To halve the standard error, quadruple the sample size
- There are diminishing returns to increasing sample size
{{< /spoiler >}}

### 6. Sampling from a Normal Population

When our population is normal, we can determine the exact distribution of our sample statistics.

{{< spoiler text="👉 Normal Sample Mean" >}}
{{< math >}}
$$\text{If } X_1, X_2, \ldots, X_n \sim N(\mu, \sigma^2) \text{ independently, then:}$$
$$\bar{X} \sim N\left(\mu, \frac{\sigma^2}{n}\right)$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Chi-Square Distribution of Sample Variance" >}}
{{< math >}}
$$\text{If } X_1, X_2, \ldots, X_n \sim N(\mu, \sigma^2) \text{ independently, then:}$$
$$\frac{(n-1)S^2}{\sigma^2} \sim \chi^2_{n-1}$$
$$\text{where } \chi^2_{n-1} \text{ denotes the chi-square distribution with } n-1 \text{ degrees of freedom.}$$
{{< /math >}}
{{< /spoiler >}}

### 7. The Central Limit Theorem

One of the most remarkable results in statistics is that sample means tend to be approximately normal, even when the original population isn't!

{{< spoiler text="👉 Central Limit Theorem" >}}
{{< math >}}
$$\text{Let } X_1, X_2, \ldots, X_n \text{ be i.i.d. random variables with mean } \mu \text{ and standard deviation } \sigma \text{ (} \sigma \neq 0 \text{)}$$
$$\text{following a distribution D. Consider the sum}$$
$$S_n = X_1 + X_2 + \cdots + X_n$$
$$\text{For n large enough, } S_n \text{ follows approximately a normal distribution:}$$
$$S_n \sim N(n\mu, n\sigma^2)$$
{{< /math >}}

To express this formally, define:
- X̄ₙ = Sₙ/n = (X₁ + X₂ + ⋯ + Xₙ)/n
- The standardized variable: Zₙ = (X̄ₙ - μ)/(σ/√n)

Then as n → ∞:
Zₙ →ᵈ N(0, 1)
where →ᵈ denotes convergence in distribution.

The CLT tells us:
1. Shape: The distribution of X̄ becomes approximately normal for large n
2. Center: X̄ is centered at the true mean μ
3. Spread: The standard error σ/√n tells us precision improves with sample size
4. Standardization: (X̄-μ)/(σ/√n) has approximately standard normal distribution
{{< /spoiler >}}

### 8. Two-Sample Statistics and Relationships

When working with multiple samples or variables, we're often interested in understanding their relationships.

{{< spoiler text="👉 Covariance" >}}
{{< math >}}
$$\text{For two random variables X and Y, the population covariance is:}$$
$$\text{Cov}(X, Y) = E[(X - \mu_X)(Y - \mu_Y)] = E(XY) - E(X)E(Y)$$
$$\text{For a sample of paired observations } (X_1, Y_1), \ldots, (X_n, Y_n), \text{ the sample covariance is:}$$
$$s_{XY} = \frac{1}{n-1}\sum_{i=1}^{n}(X_i - \bar{X})(Y_i - \bar{Y})$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Correlation Coefficient" >}}
{{< math >}}
$$\text{The correlation coefficient scales covariance to be between -1 and 1:}$$
$$\rho_{XY} = \frac{\text{Cov}(X, Y)}{\sigma_X\sigma_Y}$$
$$\text{Its sample version is:}$$
$$r_{XY} = \frac{s_{XY}}{s_X s_Y}$$
$$\text{where } s_X \text{ and } s_Y \text{ are the sample standard deviations.}$$
{{< /math >}}

Important points about correlation:
- Zero correlation doesn't imply independence
- Only measures linear relationships
- Sensitive to outliers
- Unchanged by linear transformations
{{< /spoiler >}}

{{< spoiler text="👉 Properties of Covariance" >}}
{{< math >}}
$$\text{For random variables X, Y, and constants a, b, c, d:}$$
$$\text{1. Cov}(X, X) = \text{Var}(X)$$
$$\text{2. Cov}(X, Y) = \text{Cov}(Y, X)$$
$$\text{3. Cov}(aX + b, cY + d) = ac\text{Cov}(X, Y)$$
$$\text{4. If X and Y are independent, then Cov}(X, Y) = 0$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Two-Sample Statistics" >}}
{{< math >}}
$$\text{For independent samples } X_1, \ldots, X_n \text{ and } Y_1, \ldots, Y_m:$$
$$\text{• Difference of means: } \bar{X} - \bar{Y}$$
$$\text{• Standard error: } SE(\bar{X} - \bar{Y}) = \sqrt{\frac{s^2_X}{n} + \frac{s^2_Y}{m}}$$
$$\text{• Pooled variance (if } \sigma^2_X = \sigma^2_Y):$$
$$s^2_p = \frac{(n-1)s^2_X + (m-1)s^2_Y}{n + m - 2}$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Two-Sample Normal Means" >}}
{{< math >}}
$$\text{If } X_i \sim N(\mu_X, \sigma^2) \text{ and } Y_j \sim N(\mu_Y, \sigma^2) \text{ independently with common variance, then:}$$
$$\frac{(\bar{X} - \bar{Y}) - (\mu_X - \mu_Y)}{s_p\sqrt{\frac{1}{n} + \frac{1}{m}}} \sim t_{n+m-2}$$
$$\text{where } t_{n+m-2} \text{ is Student's t-distribution with } n + m - 2 \text{ degrees of freedom.}$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Paired vs Independent Samples" >}}
Choose analysis method based on data structure:
- Paired samples:
  - Same subjects measured twice
  - Natural pairs (e.g., twins)
  - Analyze differences directly
- Independent samples:
  - Different subjects in each group
  - Use two-sample procedures
  - Often requires larger total sample
{{< /spoiler >}}

## Chapter 2.3 - Point Estimation

### 1. Introduction to Estimation

Statistical estimation is about using sample data to make educated guesses about population parameters.

{{< spoiler text="👉 Estimator and Estimate" >}}
{{< math >}}
$$\text{Given a sample } X_1, X_2, \ldots, X_n:$$
$$\text{• An estimator } \hat{\theta} \text{ is a function of the sample data used to estimate a population parameter } \theta$$
$$\text{• An estimate is the specific value obtained when we apply the estimator to actual data}$$
$$\text{• We write } \hat{\theta} \text{ for the estimator and } \hat{\theta}(x_1, \ldots, x_n) \text{ for a specific estimate}$$
{{< /math >}}
{{< /spoiler >}}

We often have multiple possible estimators for the same parameter (e.g., mean, median, trimmed mean). How do we choose between them? This leads us to study properties of estimators.

### 2. Properties of Estimators

{{< spoiler text="👉 Unbiasedness" >}}
{{< math >}}
$$\text{An estimator } \hat{\theta} \text{ is unbiased for parameter } \theta \text{ if:}$$
$$E(\hat{\theta}) = \theta$$
$$\text{for all possible values of } \theta. \text{ The bias of an estimator is:}$$
$$\text{Bias}(\hat{\theta}) = E(\hat{\theta}) - \theta$$
{{< /math >}}
{{< /spoiler >}}

{{< spoiler text="👉 Mean Squared Error" >}}
{{< math >}}
$$\text{The Mean Squared Error (MSE) of an estimator } \hat{\theta} \text{ is:}$$
$$\text{MSE}(\hat{\theta}) = E[(\hat{\theta} - \theta)^2] = \text{Var}(\hat{\theta}) + [\text{Bias}(\hat{\theta})]^2$$
{{< /math >}}

The MSE formula shows that estimation error comes from two sources:
- Variance: how much θ̂ varies around its mean
- Bias: how far E(θ̂) is from θ

Sometimes we accept a small bias to reduce variance and get a lower MSE.
{{< /spoiler >}}

{{< spoiler text="👉 Consistency" >}}
{{< math >}}
$$\text{An estimator } \hat{\theta}_n \text{ based on sample size n is consistent if it converges in probability to } \theta:$$
$$\hat{\theta}_n \stackrel{p}{\rightarrow} \theta$$
$$\text{That is, for any } \epsilon > 0:$$
$$\lim_{n\rightarrow\infty}P(|\hat{\theta}_n - \theta| > \epsilon) = 0$$
{{< /math >}}
{{< /spoiler >}}

## Practice Exercises

[Sampling Theory](#) <!-- This will be replaced with the actual link once the spreadsheet is uploaded -->
[Point estimation](#) <!-- This will be replaced with the actual link once the spreadsheet is uploaded -->


## Summary of Key Concepts

- **Sampling Theory:** Provides methods for collecting and analyzing sample data to make inferences about a population
- **Sample Statistics:** Measurable quantities calculated from a sample (e.g., mean, variance) that estimate population parameters
- **Central Limit Theorem:** States that the sampling distribution of the mean approaches a normal distribution as sample size increases, regardless of the original population's distribution
- **Point Estimation:** Methods for using sample data to calculate single values that estimate population parameters
- **Estimator Properties:** Includes unbiasedness, efficiency, consistency, and mean squared error

The concepts in these chapters provide the foundation for statistical inference, allowing us to draw valid conclusions about populations based on sample data.