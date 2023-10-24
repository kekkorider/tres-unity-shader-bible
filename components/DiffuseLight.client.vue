<template>
	<TresCanvas v-bind="gl" window-size>
		<StatsGl />

		<TresPerspectiveCamera :position="[0, 2, 4]" :look-at="[0, 0, 0]" />

		<TresGridHelper />

		<Suspense>
			<DiffuseSphere ref="meshRef" :position="[0, 0, 0]" />
		</Suspense>

		<TresObject3D ref="lightRef" :position="[1.3, 0, 1.3]" />
		<TransformControls :object="lightRef" />
	</TresCanvas>
</template>

<script setup>
import { useRenderLoop } from '@tresjs/core'
import { StatsGl, useTweakPane } from '@tresjs/cientos'

const meshRef = shallowRef(null)
const lightRef = shallowRef(null)

const { onLoop } = useRenderLoop()

const gl = {
	clearColor: '#1c1c1c',
	powerPreference: 'high-performance',
}

const config = shallowReactive({
	envLight: { r: 1, g: 1, b: 1 },
	envLightIntensity: 0.3,

	pointLightColor: { r: 1, g: 1, b: 1 },
	pointLightIntensity: 0.5,

	aoMapIntensity: 0.8,

	displacement: 0.04,

	specularIntensity: 0.5,
	specularPower: 32,
	specularColor: { r: 1, g: 1, b: 1 },
})

onMounted(async () => {
	await nextTick()

	onLoop(() => {
		if (!!!meshRef.value) return

		meshRef.value.$el.material.uniforms.u_PointLightPosition.value =
			lightRef.value.position

		// meshRef.value.$el.rotation.y += 0.01
	})

	createDebugPanel()
})

function createDebugPanel() {
	const { pane } = useTweakPane()

	// Displacement
	const displacementFolder = pane.addFolder({
		title: 'Displacement',
	})

	displacementFolder
		.addBinding(config, 'displacement', {
			label: 'Displacement',
			min: 0,
			max: 0.15,
			step: 0.001,
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_Displacement.value = value
		})

	// Environment light
	const envLightFolder = pane.addFolder({
		title: 'Environment light',
	})

	envLightFolder
		.addBinding(config, 'envLight', {
			label: 'Env light',
			view: 'color',
			color: {
				type: 'float',
			},
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_EnvLight.value.setRGB(
				value.r,
				value.g,
				value.b
			)
		})

	envLightFolder
		.addBinding(config, 'envLightIntensity', {
			label: 'Env light intensity',
			min: 0,
			max: 1,
			step: 0.01,
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_EnvLightIntensity.value = value
		})

	// Point Light
	const pointLightFolder = pane.addFolder({
		title: 'Point light',
	})

	pointLightFolder
		.addBinding(config, 'pointLightColor', {
			label: 'Point light color',
			view: 'color',
			color: {
				type: 'float',
			},
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_PointLightColor.value.setRGB(
				value.r,
				value.g,
				value.b
			)
		})

	pointLightFolder
		.addBinding(config, 'pointLightIntensity', {
			label: 'Point light intensity',
			min: 0,
			max: 1,
			step: 0.01,
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_PointLightIntensity.value = value
		})

	// Ambient occlusion
	const aoFolder = pane.addFolder({
		title: 'Ambient occlusion',
	})

	aoFolder
		.addBinding(config, 'aoMapIntensity', {
			label: 'AO map intensity',
			min: 0,
			max: 1,
			step: 0.01,
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_AoMapIntensity.value = value
		})

	// Specular
	const specularFolder = pane.addFolder({
		title: 'Specular',
	})

	specularFolder
		.addBinding(config, 'specularIntensity', {
			label: 'Intensity',
			min: 0,
			max: 1,
			step: 0.01,
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_SpecularIntensity.value = value
		})

	specularFolder
		.addBinding(config, 'specularPower', {
			label: 'Power',
			min: 1,
			max: 128,
			step: 1,
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_SpecularPower.value = value
		})

	specularFolder
		.addBinding(config, 'specularColor', {
			label: 'Color',
			view: 'color',
			color: {
				type: 'float',
			},
		})
		.on('change', ({ value }) => {
			meshRef.value.$el.material.uniforms.u_SpecularColor.value.setRGB(
				value.r,
				value.g,
				value.b
			)
		})
}
</script>
