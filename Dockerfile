# EOL: April 2025
FROM ubuntu:20.04

COPY docker/install-system-deps.bash /tmp/
RUN /tmp/install-system-deps.bash

COPY docker/install-shellspec.bash /tmp/
RUN /tmp/install-shellspec.bash
