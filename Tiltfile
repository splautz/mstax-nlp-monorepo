# Register Main docker compose file
docker_compose("docker-compose.yml")

# Set the maximum parallel updating images (default is 3)
update_settings(max_parallel_updates=5)

######################
# Frontend Services
######################

# Specify front end services in this application stack
frontend = ["files-ui"]

def register_frontend():
    image_name = "nlp-app/" + frontend[0]
    docker_build(
        ref=image_name,
        context="./mstax-ui-files",
        dockerfile="./mstax-ui-files/Dockerfile",
        live_update=[
            sync("./mstax-ui-files/src", "/app/src"),
        ],
        ignore=["coverage", "node_modules"],
    )
    dc_resource(frontend[0], labels=["frontend"])


register_frontend()


######################
# Backend Services
######################

python_servers = ["api-files", 'nlp-api']

# Specify all backend services in this application stack
backend = {
    "api-files": {"docs": "http://localhost:5001/docs", "project_dir": "mstax-api-files", "dockerfile": "Dockerfile"},
    "nlp-api": {"docs": "http://localhost:5030/docs", "project_dir": "mstax-machine-learning-poc", "dockerfile": "Dockerfile.dev"},
}


def register_backend():
    for service in backend:
        build_path = "./" + backend[service]["project_dir"]
        build_image(service, build_path)
        dc_resource(
            name=service,
            labels=["backend"],
            links=[backend[service]["docs"]],
            resource_deps=["elastic"],
        )

def build_image(service, build_path):
    dev_image_name = "nlp-app/" + service
    dev_dockerfile = build_path + '/' + backend[service]['dockerfile']
    build_python_image(dev_image_name, dev_dockerfile, build_path)

def build_python_image(dev_image_name, dev_dockerfile, build_path):
    requirements_path = build_path + "/requirements.txt"
    docker_build(
        ref=dev_image_name,
        context=build_path,
        dockerfile=dev_dockerfile,
        live_update=[
            sync(build_path, "/usr/src"),
            run(
                "pip install -r requirements.txt",
                trigger=requirements_path,
            )
        ]
    )

register_backend()

######################
# Datastores
######################

# Specify all data stores in this application stack
datastores = ["elastic"]

docker_build(
    "nlp-app/elasticsearch",
    "./elasticsearch/",
    dockerfile="./elasticsearch/Dockerfile.elastic",
)

def register_datastores():
    for datastore in datastores:
        dc_resource(name=datastore, labels=["datastores"])

register_datastores()