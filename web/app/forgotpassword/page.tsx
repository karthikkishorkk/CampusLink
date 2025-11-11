"use client";

import { useState } from "react";
import { useSupabase } from "@/lib/supabaseProvider";
import { Mail } from "lucide-react";

export default function ForgotPasswordPage() {
  const { supabase } = useSupabase();
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");

  const handleReset = async (e: React.FormEvent) => {
    e.preventDefault();
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: "http://localhost:3000/reset-password",
    });

    if (error) setMessage(error.message);
    else setMessage("Password reset link sent! Check your email.");
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#fdf8f6]">
      <div className="bg-white shadow-md rounded-xl p-8 w-[95%] sm:w-[400px]">
        <h1 className="text-2xl font-bold text-[#7c183d] mb-6 flex items-center gap-2 justify-center">
          <Mail className="w-6 h-6" /> Forgot Password
        </h1>

        <form onSubmit={handleReset} className="space-y-4">
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter your registered email"
            required
            className="w-full border rounded-md px-3 py-2 focus:ring-2 focus:ring-[#7c183d]"
          />

          <button
            type="submit"
            className="w-full bg-[#7c183d] text-white py-2 rounded-md hover:bg-[#61122e]"
          >
            Send Reset Link
          </button>
        </form>

        {message && (
          <p className="text-center text-sm mt-3 text-[#7c183d]">{message}</p>
        )}
      </div>
    </div>
  );
}
