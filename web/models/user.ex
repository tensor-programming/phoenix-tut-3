defmodule Chatter.User do
  use Chatter.Web, :model

  schema "users" do
    field :email, :string
    field :encrypt_pass, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

   def reg_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 5)
    |> hash_pw()
  end

  defp hash_pw(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: p}} ->
        put_change(changeset, :encrypt_pass, Comeonin.Pbkdf2.hashpwsalt(p))

      _ -> 
        changeset
    end
  end

  
end
