from datetime import datetime
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.providers.standard.operators.bash import BashOperator      # Airflow 3 import

DBT = "/opt/airflow/dbt_venv/bin/dbt"
DBT_PROJECT = "/opt/airflow/dbt/doordash"

COPY_RAW = [
    "USE WAREHOUSE DE_PROJECT",
    "COPY INTO DOORDASH.RAW.restaurant FROM @DOORDASH.RAW.DOORDASH_INTERNAL_STAGE/restaurant/  ON_ERROR='CONTINUE'",
    "COPY INTO DOORDASH.RAW.users       FROM @DOORDASH.RAW.DOORDASH_INTERNAL_STAGE/users/        ON_ERROR='CONTINUE'",
    "COPY INTO DOORDASH.RAW.food        FROM @DOORDASH.RAW.DOORDASH_INTERNAL_STAGE/food/         ON_ERROR='CONTINUE'",
    "COPY INTO DOORDASH.RAW.menu        FROM @DOORDASH.RAW.DOORDASH_INTERNAL_STAGE/menu/         ON_ERROR='CONTINUE'",
    "COPY INTO DOORDASH.RAW.orders      FROM @DOORDASH.RAW.DOORDASH_INTERNAL_STAGE/orders/",
    "COPY INTO DOORDASH.RAW.order_items FROM @DOORDASH.RAW.DOORDASH_INTERNAL_STAGE/order_items/",
    "COPY INTO DOORDASH.RAW.reviews     FROM @DOORDASH.RAW.DOORDASH_INTERNAL_STAGE/reviews/",
]

with DAG(
    dag_id="doordash_batch",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["doordash", "dbt", "snowflake"],
    doc_md=__doc__,
) as dag:

    reload_raw = SQLExecuteQueryOperator(
        task_id="reload_raw", conn_id="snowflake_default",
        sql=COPY_RAW, split_statements=True, autocommit=True,
    )

    dbt_build_core = BashOperator(
        task_id="dbt_build_core",
        bash_command=f"{DBT} build --exclude tag:ai --project-dir {DBT_PROJECT} --profiles-dir {DBT_PROJECT}",
    )

    enrich_reviews = BashOperator(
        task_id="enrich_reviews",
        bash_command=f"python /opt/airflow/ai/enrich_reviews.py",
    )

    dbt_build_ai = BashOperator(
        task_id = "dbt_build_ai",
        bash_command=f"{DBT} build --select tag:ai --project-dir {DBT_PROJECT} --profiles-dir {DBT_PROJECT}"
    )

    reload_raw >> dbt_build_core >> enrich_reviews >> dbt_build_ai