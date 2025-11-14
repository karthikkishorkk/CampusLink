"use client";

import { useEffect, useState } from "react";
import { FileText, Eye, Trash2 } from "lucide-react";
import { supabaseBrowser } from "@/lib/supabase-browser";

export default function DocumentsPage() {
  const supabase = supabaseBrowser;
  const [documents, setDocuments] = useState<any[]>([]);
  const [filter, setFilter] = useState("All");
  const [loading, setLoading] = useState(true);

  const fetchDocuments = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from("alerts")
      .select("id, title, type, created_at, file_url, description");

    if (!error && data) {
      // Filter only alerts that have attached files
      const docs = data.filter((d) => d.file_url);
      setDocuments(docs);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchDocuments();
  }, []);

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this document?")) return;

    try {
      const { error } = await supabase.from("alerts").delete().eq("id", id);
      if (error) throw error;
      alert("🗑️ Document deleted successfully!");
      fetchDocuments();
    } catch (error: any) {
      console.error("Delete failed:", error.message);
      alert("❌ Failed to delete document.");
    }
  };

  const filteredDocs =
    filter === "All" ? documents : documents.filter((d) => d.type === filter);

  return (
    <div className="p-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-3xl font-bold text-[#8B1538] flex items-center gap-2">
          <FileText className="w-7 h-7" /> Document Repository
        </h1>

        <select
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          className="border border-gray-300 rounded-lg p-2 text-sm focus:ring-2 focus:ring-[#8B1538]"
        >
          <option>All</option>
          <option>Alert</option>
          <option>Circular</option>
          <option>Event</option>
        </select>
      </div>

      {/* Loading / Empty State */}
      {loading ? (
        <div className="text-gray-500 text-center py-10">Loading documents...</div>
      ) : filteredDocs.length === 0 ? (
        <p className="text-gray-500 text-center">No documents found.</p>
      ) : (
        <div className="bg-white border border-[#8B1538]/20 rounded-xl shadow-sm overflow-hidden">
          <table className="w-full border-collapse">
            <thead className="bg-[#F5E6D3]/70">
              <tr>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Document Name</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Type</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Uploaded On</th>
                <th className="text-left py-3 px-4 border-b text-[#8B1538]">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredDocs.map((doc) => (
                <tr key={doc.id} className="border-b hover:bg-[#F5E6D3]/40">
                  <td className="py-3 px-4 text-[#2C1810]">{doc.title}</td>
                  <td className="py-3 px-4 text-[#2C1810]">{doc.type}</td>
                  <td className="py-3 px-4 text-[#2C1810]">
                    {new Date(doc.created_at).toLocaleDateString()}
                  </td>
                  <td className="py-3 px-4 flex items-center gap-4 text-sm">
                    <a
                      href={`https://ehwcukgswuhjdcgjnruv.supabase.co/storage/v1/object/public/alerts-files/${doc.file_url}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-1 text-blue-600 hover:underline font-medium"
                    >
                      <Eye className="w-4 h-4" /> View
                    </a>
                    <button
                      onClick={() => handleDelete(doc.id)}
                      className="flex items-center gap-1 text-red-600 hover:underline font-medium"
                    >
                      <Trash2 className="w-4 h-4" /> Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
