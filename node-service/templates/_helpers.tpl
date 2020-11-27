{{/*
Attach LivenessProbe on Pod/deployment
*/}}
{{- define "node-service.livenessProbe" -}}
{{ toYaml .Values.healthCheckConfig }}
{{- end }}
{{/*
Attach ReadinessProbe on Pod/deployment
*/}}
{{- define "node-service.readinessProbe" -}}
{{ toYaml .Values.healthCheckConfig }}
{{- end }}