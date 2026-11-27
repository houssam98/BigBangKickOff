-- THE BIG BANG KICKOFF: run this ONCE in Supabase > SQL Editor > New query > Run

create table if not exists public.members (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  club        text not null check (club in ('gn7','gdg','aws')),
  grp         text not null check (grp  in ('bur','out','par')),   -- bureau 2026-27 / bureau sortant / parrain
  role        text not null check (char_length(role)       between 1 and 60),
  first_name  text not null check (char_length(first_name) between 1 and 40),
  last_name   text not null check (char_length(last_name)  between 1 and 40),
  photo_path  text check (photo_path is null or char_length(photo_path) < 200),
  slot        int  check (slot between 0 and 11),                   -- optional: force a position on the slide
  approved    boolean not null default false
);

alter table public.members enable row level security;

-- Visitors (the deck) can only READ approved rows
drop policy if exists "read approved"  on public.members;
create policy "read approved" on public.members for select to anon using (approved = true);

-- Members can only SUBMIT new rows, always pending, never choosing a slot
drop policy if exists "submit pending" on public.members;
create policy "submit pending" on public.members for insert to anon
  with check (approved = false and slot is null);

-- Admin (logged-in user) can do everything
drop policy if exists "admin all" on public.members;
create policy "admin all" on public.members for all to authenticated using (true) with check (true);

-- Photo storage: public bucket, JPEG only, 1 MB max per file
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('photos', 'photos', true, 1048576, array['image/jpeg'])
on conflict (id) do update set public = true, file_size_limit = 1048576, allowed_mime_types = array['image/jpeg'];

drop policy if exists "upload photos" on storage.objects;
create policy "upload photos" on storage.objects for insert to anon with check (bucket_id = 'photos');

drop policy if exists "admin photos" on storage.objects;
create policy "admin photos" on storage.objects for all to authenticated
  using (bucket_id = 'photos') with check (bucket_id = 'photos');

-- Table permissions (required on newer Supabase projects; Row Level Security above still limits what each role can do)
grant usage on schema public to anon, authenticated;
grant select, insert on public.members to anon;
grant select, insert, update, delete on public.members to authenticated;
