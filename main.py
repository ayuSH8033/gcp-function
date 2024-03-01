from os import getenv
import functions_framework
from flask import Request, Response
import importlib


MAIN_MODULE = getenv('MAIN_MODULE')
MAIN_FUNC_ENTRY = getenv("MAIN_FUNC_ENTRY", "main.lambda_handler")


@functions_framework.http
def lambda_handler(request: Request) -> Response:
    main_package = MAIN_FUNC_ENTRY.rsplit(".", 1)[0]
    main_function = MAIN_FUNC_ENTRY.rsplit(".", 1)[1]
    main_mod = importlib.import_module(MAIN_MODULE + "." + main_package)

    return main_mod.__getattribute__(main_function)(request)
