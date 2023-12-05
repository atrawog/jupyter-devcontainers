group "default" {
  targets = ["micromamba", "python", "jupyter", "ansible", "ai", "spatial", "devel"]
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

target "ansible" {
  tags = ["ORG_PLACEHOLDER/ansible:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/ansible:DATE_TAG_PLACEHOLDER"]
  target = "ansible"
  inherit = ["jupyter"]
}

target "ai" {
  tags = ["ORG_PLACEHOLDER/ai:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/ai:DATE_TAG_PLACEHOLDER"]
  target = "ai"
  inherit = ["jupyter"]
}

target "spatial" {
  tags = ["ORG_PLACEHOLDER/spatial:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/spatial:DATE_TAG_PLACEHOLDER"]
  target = "spatial"
  inherit = ["ai"]
}

target "testing" {
  tags = ["ORG_PLACEHOLDER/testing:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/testing:DATE_TAG_PLACEHOLDER"]
  target = "testing"
  inherit = ["spatial"]
}

target "devel" {
  tags = ["ORG_PLACEHOLDER/devel:DEFAULT_TAG_PLACEHOLDER", "ORG_PLACEHOLDER/devel:DATE_TAG_PLACEHOLDER"]
  target = "devel"
  inherit = ["testing"]
}
