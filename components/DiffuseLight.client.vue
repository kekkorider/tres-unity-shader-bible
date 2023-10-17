<template>
	<TresCanvas v-bind="gl" window-size>
		<StatsGl />

		<TresPerspectiveCamera :position="[0, 2, 4]" :look-at="[0, 0, 0]" />

		<TresGridHelper />

		<Suspense>
			<DiffuseSphere ref="meshRef" :position="[0, 0, 0]" />
		</Suspense>

		<TresObject3D ref="lightRef" :position="(0, 3, 0)" />
		<TransformControls :object="lightRef" />
	</TresCanvas>
</template>

<script setup>
import { useRenderLoop } from '@tresjs/core'
import { StatsGl } from '@tresjs/cientos'

const meshRef = shallowRef(null)
const lightRef = shallowRef(null)

const { onLoop } = useRenderLoop()

const gl = {
	clearColor: '#1c1c1c',
	powerPreference: 'high-performance',
}

onMounted(async () => {
	await nextTick()

	onLoop(() => {
		if (!!!meshRef.value) return

		meshRef.value.$el.material.uniforms.u_LightPosition.value =
			lightRef.value.position

		meshRef.value.$el.rotation.y += 0.01
	})
})
</script>
