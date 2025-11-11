"use client";

import { createContext, useContext, useEffect, useState } from "react";
import {
  createPagesBrowserClient,
  Session,
} from "@supabase/auth-helpers-nextjs";

type SupabaseContextType = {
  supabase: ReturnType<typeof createPagesBrowserClient>;
  session: Session | null;
};

const Context = createContext<SupabaseContextType | undefined>(undefined);

export default function SupabaseProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  const [supabase] = useState(() => createPagesBrowserClient());
  const [session, setSession] = useState<Session | null>(null);

  useEffect(() => {
    // ✅ Only run this after mount
    const getInitialSession = async () => {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      setSession(session);
    };

    getInitialSession();

    // ✅ Subscribe to auth changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
    });

    // ✅ Clean up subscription when component unmounts
    return () => {
      subscription.unsubscribe();
    };
  }, [supabase]);

  return (
    <Context.Provider value={{ supabase, session }}>
      {children}
    </Context.Provider>
  );
}

export const useSupabase = () => {
  const ctx = useContext(Context);
  if (!ctx) throw new Error("useSupabase must be used within SupabaseProvider");
  return ctx;
};
