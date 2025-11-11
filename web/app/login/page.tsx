"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useSupabase } from "@/components/supabase-provider";
import { LogIn } from "lucide-react";

export default function LoginPage() {
  const router = useRouter();
  const { supabase } = useSupabase();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errorMsg, setErrorMsg] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrorMsg("");

    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    setLoading(false);

    if (error) {
      setErrorMsg(error.message);
      return;
    }

    // give cookie a tick to sync before redirect
    setTimeout(() => {
      router.replace("/admin/dashboard");
    }, 300);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#fdf8f6]">
      <div className="bg-white shadow-md rounded-xl p-8 w-[95%] sm:w-[400px]">
        <h1 className="text-2xl font-bold text-[#7c183d] mb-6 flex items-center gap-2 justify-center">
          <LogIn className="w-6 h-6" /> Admin Login
        </h1>

        <form onSubmit={handleLogin} className="space-y-4">
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full border rounded-md px-3 py-2"
            required
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full border rounded-md px-3 py-2"
            required
          />
          {errorMsg && <p className="text-red-600 text-sm">{errorMsg}</p>}
          <button
            type="submit"
            disabled={loading}
            className="w-full bg-[#7c183d] text-white py-2 rounded-md hover:bg-[#61122e]"
          >
            {loading ? "Logging in..." : "Login"}
          </button>
        </form>
      </div>
    </div>
  );
}
