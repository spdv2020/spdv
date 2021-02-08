<template>
  <div class="container-fluid bg-login h-100">
    <!-- Outer Row -->
    <div class="row justify-content-center align-items-center h-100">
      <div class="col-xl-7 col-lg-12 col-md-9">
        <div class="card o-hidden border-0 shadow-lg">
          <div class="card-body p-0">
            <!-- Nested Row within Card Body -->
            <div class="row">
              <div class="col-lg-5 d-none d-lg-block bg-login-image"></div>
              <div class="col-lg-7">
                <div class="p-5">
                  <div class="text-center">
                    <h1 class="h4 text-gray-900 mb-4">{{ title }}</h1>
                  </div>
                  <form class="user" @submit="onSubmit">
                    <div class="form-group">
                      <input
                        type="email"
                        class="form-control"
                        aria-describedby="emailHelp"
                        autocomplete="off"
                        placeholder="Email"
                        name="username"
                        v-model="username"
                        v-focus
                        :class="{ 'is-invalid': !!errors.username }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.username || 'default' }}</small>
                      </div>
                    </div>
                    <div class="form-group">
                      <input
                        type="password"
                        class="form-control"
                        id="exampleInputPassword"
                        placeholder="Senha"
                        name="password"
                        v-model="password"
                        :class="{ 'is-invalid': !!errors.password }"
                      />
                      <div class="invalid-feedback">
                        <small>{{ errors.password || 'default' }}</small>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="custom-control custom-checkbox small">
                        <input type="checkbox" class="custom-control-input" id="customCheck" />
                        <label class="custom-control-label" for="customCheck">Lembrar-me</label>
                      </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                  </form>
                  <hr />
                  <!-- <div class="text-center">
                    <a class="small" href="forgot-password.html">Esqueceu a senha?</a>
                  </div> -->
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

import { useRouter } from 'vue-router'

import * as yup from 'yup'
import { useForm, useField } from 'vee-validate'

export default defineComponent({
  name: 'Login',

  props: {
    title: String
  },

  setup () {
    const router = useRouter()

    const schema = yup.object({
      username: yup.string().required().email(),
      password: yup.string().required().min(8)
    })

    const { errors, handleSubmit } = useForm({ validationSchema: schema })

    const { value: username } = useField('username')
    const { value: password } = useField('password')

    const onSubmit = handleSubmit(values => {
      console.log(values)
      router.push({ name: 'admin.dashboard' })
    })

    return {
      errors,

      username,
      password,

      onSubmit
    }
  }
})
</script>

<style lang="scss" scoped>
.bg-login {
  background-color: #fff;
  background-image: linear-gradient(
    160deg,
    #fff 0%,
    theme-color('primary') 100%
  );
}

.bg-login-image {
  background: url($login-image);
  background-position: center;
  background-size: cover;
}

form.user {
  .custom-checkbox.small {
    label {
      line-height: 1.5rem;
    }
  }
}
</style>
