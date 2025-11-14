"use client";

import { useState } from "react";
import { X } from "lucide-react";
import { supabaseBrowser } from "@/lib/supabase-browser";

interface EditAlertModalProps {
  alertData: any;
  onClose: () => void;
  refresh: () => Promise<void> | void;
}

export default function EditAlertModal({
  alertData,
  onClose,
  refresh,
}: EditAlertModalProps) {
  const supabase = supabaseBrowser;

  const [title, setTitle] = useState(alertData.title);
  const [description, setDescription] = useState(alertData.description);
  const [type, setType] = useState(alertData.type);
  const [startDate, setStartDate] = useState(alertData.start_date || "");
  const [endDate, setEndDate] = useState(alertData.end_date || "");
  const [file, setFile] = useState<File | null>(null);
  const [loading, setLoading] = useState(false);

  const handleUpdate = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      let relativePath = alertData.file_url; // keep old path unless replaced

      // If user selects a new file
      if (file) {
        const ext = file.name.split(".").pop();
        const fileName = `${Date.now()}-${Math.random()
          .toString(36)
          .slice(2)}.${ext}`;
        const filePath = `alerts/${fileName}`;

        const { data: uploadData, error: uploadError } =
          await supabase.storage
            .from("alerts-files")
            .upload(filePath, file, {
              upsert: true,
              cacheControl: "3600",
              contentType: file.type || "application/pdf",
            });

        if (uploadError) throw uploadError;

        relativePath = uploadData?.path ?? filePath;
      }

      // Update alert
      const { error } = await supabase
        .from("alerts")
        .update({
          title,
          description,
          type,
          start_date: type === "Event" ? startDate : null,
          end_date: type === "Event" ? endDate : null,
          file_url: relativePath, // save ONLY relative path
        })
        .eq("id", alertData.id);

      if (error) throw error;

      alert("Updated successfully!");
      refresh();
      onClose();
    } catch (err: any) {
      console.error("Update failed:", err);
      alert("Failed to update alert.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black/50 z-50">
      <div className="bg-white w-[500px] rounded-xl shadow-2xl p-6 relative">
        <button
          onClick={onClose}
          className="absolute top-3 right-3 text-gray-500 hover:text-red-500"
        >
          <X className="w-5 h-5" />
        </button>

        <h2 className="text-2xl font-semibold text-[#8B1538] mb-4">
          Edit Alert / Circular
        </h2>

        <form onSubmit={handleUpdate} className="space-y-4">
          <input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full border border-gray-300 rounded-lg p-2"
            required
          />

          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="w-full border border-gray-300 rounded-lg p-2"
            required
          ></textarea>

          <select
            value={type}
            onChange={(e) => setType(e.target.value)}
            className="w-full border border-gray-300 rounded-lg p-2"
          >
            <option value="Alert">Alert</option>
            <option value="Circular">Circular</option>
            <option value="Event">Event</option>
          </select>

          {type === "Event" && (
            <div className="grid grid-cols-2 gap-3">
              <input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="border rounded-lg p-2"
                required
              />
              <input
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                className="border rounded-lg p-2"
                required
              />
            </div>
          )}

          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">
              Replace PDF (optional)
            </label>
            <input
              type="file"
              accept="application/pdf"
              onChange={(e) => setFile(e.target.files?.[0] || null)}
              className="w-full border border-gray-300 rounded-lg p-2"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-[#8B1538] text-white py-2 rounded-lg hover:bg-[#6B0F28]"
          >
            {loading ? "Updating..." : "Update Alert"}
          </button>
        </form>
      </div>
    </div>
  );
}
