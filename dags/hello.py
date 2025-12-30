from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="hello_world",
    start_date=datetime(2025, 10, 10),
    schedule=None,
    catchup=False,
) as dag:
    BashOperator(task_id="hello", bash_command="echo hello from airflow")
