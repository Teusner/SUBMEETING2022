.ONESHELL:
SHELL=/bin/bash

# Directory configuration
BUILD_DIR = build
PRESENTATION_DIR = presentation
ABSTRACT_DIR = abstract
IMAGES_DIR = images
DIAGRAMS_DIR = diagrams
SCRIPT_DIR = scripts

# Directory path combining
ABSTRACT_BUILD_DIR = $(BUILD_DIR)/$(ABSTRACT_DIR)
PRESENTATION_BUILD_DIR = $(BUILD_DIR)/$(PRESENTATION_DIR)
IMAGES_BUILD_DIR = $(BUILD_DIR)/$(IMAGES_DIR)

# TEX sources
TEX_SRCS := $(wildcard */*.sty)

# Video
VIDEOS_MP4 = $(PRESENTATION_BUILD_DIR)/sphere.mp4 $(PRESENTATION_BUILD_DIR)/localisation.mp4 $(PRESENTATION_BUILD_DIR)/proteus.mp4

# Directory guard
dir_guard = @mkdir -p $(@D)

# All recipe
all: presentation abstract

$(IMAGES_PDF): $(IMAGES_BUILD_DIR)/%.pdf : $(SCRIPT_DIR)/%.py
	$(dir_guard)
	$(CONDA_ACTIVATE) proteus ; python3 $< $@

# Video
video:
	cp images/compass.mp4 $(PRESENTATION_BUILD_DIR)/compass.mp4
	cp images/navigation.mp4 $(PRESENTATION_BUILD_DIR)/navigation.mp4

# Abstract
abstract: $(ABSTRACT_BUILD_DIR)/abstract.pdf

$(ABSTRACT_BUILD_DIR)/abstract.pdf: src/abstract.tex
	$(dir_guard)
	latexmk -pdf -shell-escape -output-directory=$(ABSTRACT_BUILD_DIR) $<

# Presentation
presentation: $(PRESENTATION_BUILD_DIR)/presentation.pdf

$(PRESENTATION_BUILD_DIR)/presentation.pdf: src/presentation.tex $(TEX_SRCS) video
	$(dir_guard)
	latexmk -pdf -shell-escape -output-directory=$(PRESENTATION_BUILD_DIR) $<

# Clean recipe
clean:
	rm -rf $(BUILD_DIR)