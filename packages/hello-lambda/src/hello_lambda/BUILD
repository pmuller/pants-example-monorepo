python_sources(name = "lib")

python_awslambda(
    name = "lambda",
    handler = "hello_lambda.py:lambda_handler",
    runtime = "python3.9",
)

python_requirement(
    name = "lambda-typing",
    requirements = ["aws-lambda-typing"],
)
