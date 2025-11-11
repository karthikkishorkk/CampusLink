"use client";

import { useEffect, useState } from "react";
import { X, Upload } from "lucide-react";
import { supabaseBrowser } from "@/lib/supabase-browser";
import { useSupabase } from "@/components/supabase-provider";

interface AddAlertModalProps {
  onClose: () => void;
  refresh: () => Promise<void> | void;
}

export default function AddAlertModal({ onClose, refresh }: AddAlertModalProps) {
  const { session } = useSupabase();

  const [adminId, setAdminId] = useState<string | null>(null);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [type, setType] = useState("Alert");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [uploading, setUploading] = useState(false);

  // ✅ Fetch admin ID based on logged-in email
  useEffect(() => {
    const fetchAdmin = async () => {
      if (!session?.user?.email) return;
      const { data, error } = await supabaseBrowser
        .from("admins")
        .select("id")
        .eq("email", session.user.email)
        .single();
      if (data && !error) setAdminId(data.id);
    };
    fetchAdmin();
  }, [session]);

  // ✅ Handle file + alert upload
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!adminId) {
      alert("Admin record not found! Please ensure your email is in the admins table.");
      return;
    }

    setUploading(true);
    let fileUrl: string | null = null;

    try {
      // Upload file to Supabase Storage if selected
      if (file) {
        const fileExt = file.name.split(".").pop();
        const fileName = `${Date.now()}-${Math.random().toString(36).slice(2)}.${fileExt}`;
        const filePath = `alerts/${fileName}`;

        const { error: uploadError } = await supabaseBrowser.storage
          .from("alerts-files")
          .upload(filePath, file, {
            cacheControl: "3600",
            upsert: true,
            contentType: file.type || "application/pdf",
          });

        if (uploadError) throw uploadError;

        // Get public URL
        const { data: publicUrl } = supabaseBrowser.storage
          .from("alerts-files")
          .getPublicUrl(filePath);

        fileUrl = publicUrl.publicUrl;
      }

      // Insert into alerts table
      const { error } = await supabaseBrowser.from("alerts").insert([
        {
          title,
          description,
          type,
          start_date: type === "Event" ? startDate : null,
          end_date: type === "Event" ? endDate : null,
          file_url: fileUrl,
          posted_by: adminId,
        },
      ]);

      if (error) throw error;

      setUploading(false);
      refresh();
      onClose();
    } catch (err: any) {
      console.error("Upload error:", err);
      alert(`Error: ${err.message || "Failed to upload alert."}`);
      setUploading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div className="bg-white rounded-xl shadow-lg w-[95%] sm:w-[500px] p-6 relative">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-500 hover:text-black"
        >
          <X className="w-5 h-5" />
        </button>

        <h2 className="text-xl font-semibold text-[#8B1538] mb-4">
          Create New Alert
        </h2>

        <form onSubmit={handleSubmit} className="space-y-4">
          {/* Title */}
          <input
            type="text"
            placeholder="Title"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full border px-3 py-2 rounded-md"
            required
          />

          {/* Description */}
          <textarea
            placeholder="Description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="w-full border px-3 py-2 rounded-md"
            required
          />

          {/* Type selector */}
          <div className="flex gap-2 items-center">
            <label className="font-medium text-sm">Type:</label>
            <select
              value={type}
              onChange={(e) => setType(e.target.value)}
              className="border rounded-md px-2 py-1"
            >
              <option>Alert</option>
              <option>Circular</option>
              <option>Event</option>
            </select>
          </div>

          {/* Event dates */}
          {type === "Event" && (
            <div className="flex gap-3">
              <input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="border rounded-md px-2 py-1 w-1/2"
                required
              />
              <input
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                className="border rounded-md px-2 py-1 w-1/2"
                required
              />
            </div>
          )}

          {/* File input */}
          <div className="flex items-center gap-2">
            <Upload className="w-4 h-4 text-[#8B1538]" />
            <input
              type="file"
              accept=".pdf"
              onChange={(e) => setFile(e.target.files?.[0] || null)}
            />
            {file && (
              <span className="text-sm text-gray-600 truncate">
                {file.name}
              </span>
            )}
          </div>

          {/* Submit button */}
          <button
            type="submit"
            disabled={uploading}
            className="w-full bg-[#8B1538] text-white py-2 rounded-md hover:bg-[#6B0F28]"
          >
            {uploading ? "Uploading..." : "Create Alert"}
          </button>
        </form>
      </div>
    </div>
  );
}
