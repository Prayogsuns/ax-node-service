{{/*
Attach LivenessProbe on Pod/deployment
*/}}
{{- define "node-service.livenessProbe" -}}
{{- if .Values.healthCheckConfig -}}
livenessProbe:
  {{ toYaml .Values.healthCheckConfig }}
{{- end -}}
{{- end }}
{{/*
Attach ReadinessProbe on Pod/deployment
*/}}
{{- define "node-service.readinessProbe" -}}
{{- if .Values.healthCheckConfig -}}
readinessProbe:
  {{ toYaml .Values.healthCheckConfig }}
{{- end -}}
{{- end }}