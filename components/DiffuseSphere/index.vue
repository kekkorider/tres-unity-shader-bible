import { Vector3 } from 'three'; import { RepeatWrapping } from 'three'; import
{ RepeatWrapping } from 'three';
<template>
	<TresMesh>
		<TresSphereGeometry :args="[1, 64, 32]" />
		<TresShaderMaterial v-bind="materialConfig" ref="materialRef" />
	</TresMesh>
</template>

<script setup>
import { useTexture } from '@tresjs/core'
import { Vector3, RepeatWrapping } from 'three'

import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

const materialRef = shallowRef(null)

const texture = await useTexture({
	map: '/bricks_albedo.png',
	normalMap: '/bricks_normal.png',
	displacementMap: '/bricks_displacement.png',
})

texture.map.wrapS = texture.map.wrapT = RepeatWrapping
texture.normalMap.wrapS = texture.normalMap.wrapT = RepeatWrapping
texture.displacementMap.wrapS = texture.displacementMap.wrapT = RepeatWrapping

const materialConfig = {
	vertexShader,
	fragmentShader,
	uniforms: {
		t_Map: {
			value: texture.map,
		},
		t_NormalMap: {
			value: texture.normalMap,
		},
		t_DisplacementMap: {
			value: texture.displacementMap,
		},
		u_WorldPosition: { value: new Vector3() },
		u_LightPosition: { value: new Vector3() },
		u_LightIntensity: { value: 0.5 },
	},
}
</script>
