group "default" {
  targets = ["micromamba", "python", "jupyter", "jupyter-ai", "jupyter-spatial", "jupyter-ansible", "jupyter-devel"]
}

target "micromamba" {
  tags = ["ORG_PLACEHOLDER/micromamba:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/micromamba:DATE_TAG_PLACEHOLDER"]
  target = "micromamba"
}

target "python" {
  tags = ["ORG_PLACEHOLDER/python:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/python:DATE_TAG_PLACEHOLDER"]
  target = "python"
  inherit = ["micromamba"]
}

target "jupyter" {
  tags = ["ORG_PLACEHOLDER/jupyter:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/jupyter:DATE_TAG_PLACEHOLDER"]
  target = "jupyter"
  inherit = ["python"]
}

target "jupyter-ai" {
  tags = ["ORG_PLACEHOLDER/jupyter-ai:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/jupyter-ai:DATE_TAG_PLACEHOLDER"]
  target = "jupyter-ai"
  inherit = ["jupyter"]
}

target "jupyter-spatial" {
  tags = ["ORG_PLACEHOLDER/jupyter-spatial:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/jupyter-spatial:DATE_TAG_PLACEHOLDER"]
  target = "jupyter-spatial"
  inherit = ["jupyter-ai"]
}

target "jupyter-ansible" {
  tags = ["ORG_PLACEHOLDER/jupyter-ansible:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/jupyter-ansible:DATE_TAG_PLACEHOLDER"]
  target = "jupyter-ansible"
  inherit = ["jupyter-spatial"]
}

target "jupyter-devel" {
  tags = ["ORG_PLACEHOLDER/jupyter-devel:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/jupyter-devel:DATE_TAG_PLACEHOLDER"]
  target = "jupyter-devel"
  inherit = ["jupyter-spatial"]
}
