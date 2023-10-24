import { Vector3 } from 'three'; import { RepeatWrapping } from 'three'; import
{ RepeatWrapping } from 'three';
<template>
	<TresMesh>
		<TresSphereGeometry ref="geometryRef" :args="[1, 64, 32]" />
		<TresShaderMaterial
			v-bind="materialConfig"
			ref="materialRef"
			name="LightMaterial"
		/>
	</TresMesh>
</template>

<script setup>
import { useTexture } from '@tresjs/core'
import { Vector3, RepeatWrapping, Color } from 'three'

import vertexShader from './vertex.glsl'
import fragmentShader from './fragment.glsl'

const geometryRef = shallowRef(null)
const materialRef = shallowRef(null)

const texture = await useTexture({
	map: '/bricks_albedo.png',
	normalMap: '/bricks_normal.png',
	displacementMap: '/bricks_displacement.png',
	aoMap: '/bricks_ao.png',
})

texture.map.wrapS = texture.map.wrapT = RepeatWrapping
texture.normalMap.wrapS = texture.normalMap.wrapT = RepeatWrapping
texture.displacementMap.wrapS = texture.displacementMap.wrapT = RepeatWrapping
texture.aoMap.wrapS = texture.aoMap.wrapT = RepeatWrapping

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

		t_AoMap: {
			value: texture.aoMap,
		},
		u_AoMapIntensity: { value: 0.8 },

		u_WorldPosition: { value: new Vector3() },

		u_PointLightPosition: { value: new Vector3() },
		u_PointLightIntensity: { value: 0.5 },
		u_PointLightColor: { value: new Color('#fff') },

		u_EnvLight: { value: new Color('#fff') },
		u_EnvLightIntensity: { value: 0.3 },

		u_Displacement: { value: 0.04 },

		u_SpecularIntensity: { value: 0.5 },
		u_SpecularPower: { value: 32 },
		u_SpecularColor: { value: new Color('#fff') },
	},
	defines: {
		USE_UV2: '',
	},
}

onMounted(async () => {
	await nextTick()

	geometryRef.value.setAttribute(
		'uv2',
		geometryRef.value.getAttribute('uv').clone()
	)
})
</script>
